# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  start                :datetime
#  stop                 :datetime
#  description          :string
#  coach_id             :integer
#  area_id              :integer
#  order_id             :integer
#  user_id              :integer
#  price                :float
#  recurrence_rule      :string
#  recurrence_exception :string
#  recurrence_id        :integer
#  is_all_day           :boolean
#  status               :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class EventsController < ApplicationController
  respond_to :json, :html
  before_filter :authenticate_user!, except: [:index, :new, :parents_events, :one_day]

  def index
    @stadium = params[:stadium].present? ? Stadium.friendly.find(params[:stadium]) : Stadium.active.first
    if params[:from] == "one_day" && params[:areas].present?
      @events = Event.scoped_by(area: Area.where(slug: params[:areas]), user: nil)
    elsif params[:from] == "one_day"
      @events = []
    elsif params[:scope] == "coach"
      @events = Event.scoped_by(coach: Coach.friendly.find(params[:coach_id]), area: current_product, user: current_user)
    elsif params[:scope] == "grid" && current_user.present? && current_user.type == "CoachUser"
      @events = Event.scoped_by(area: current_user.areas, user: current_user, coach: current_user.coach, scope: params[:scope])
    elsif current_user.present? && params[:area_id].present? && current_user.type == "StadiumUser"
      @events = Event.scoped_by(area: current_product, user: current_user, scope: params[:scope])
    elsif current_user.present? && current_user.type == "StadiumUser"
      @events = Event.scoped_by(area: current_user.areas, user: current_user, scope: params[:scope])
    elsif params[:stadium].present?
      @events = Event.scoped_by(area: @stadium.areas)
    else
      @events = Event.scoped_by(user: current_user, area: current_product, scope: params[:scope])
    end
    respond_with @events
  end

  def new
    if params[:area_id].present?
      @product = Area.friendly.find params[:area_id]
      if @product.coaches_areas.any?
        @coaches = @product.coaches_areas
      end
    end
    @event = Event.new
    @group_event = GroupEvent.new
  end

  def parents_events
    if params[:scope] == "stadium"
      stadium = Stadium.friendly.find(params[:stadium_id])
      if current_user.present?
        @events = stadium.areas.flat_map {|area| current_user.events.where(area: area)}
      else
        @events = []
      end
    end
    render :index
  end

  def one_day
    @stadium = params[:stadium].present? ? Stadium.friendly.find(params[:stadium]) : Stadium.active.first

    gon.stadium_slug = @stadium.slug
    gon.opens_at = Time.zone.parse(@stadium.opens_at.to_s)
    gon.closes_at = Time.zone.parse(@stadium.closes_at.to_s)
    if params[:areas]
      @areas = Area.where(slug: params[:areas])
    else
      @areas = @stadium.areas
    end
    gon.areas_id = @areas.map(&:slug)
  end

  def private
    @events = current_user.events
    respond_with @events do |format|
      # format.html { render layout:  }
    end
  end

  def create
    @event = current_user.events.create event_params.delete_if {|k,v| v.empty? }

    if @event.recurring?
      @events = Event.split_recurring @event
      t = ActiveRecord::Base.transaction { @events.each {|e| if e.start!= @event.start
                                                               e.save
                                                             else e.destroy
                                                             end} }
      errors = @events.map(&:errors).map(&:messages).select(&:present?)
      if errors.blank?
        respond_with @events
      else
        flash[:error] = errors.map(&:values).join(", ")
        redirect_to :back
      end
    else
      if current_user.type == "StadiumUser" && current_user.stadium.areas.include?(@event.area)
        @event.status = :locked
      end
      if @event.save
        respond_with @event
      else
        flash[:error] = t(@event.errors.messages.values.join(" "))
        redirect_to :back
      end
    end
  end

  def update
    if current_user.present? && current_user.type == "StadiumUser"
      @event = current_user.stadium_events.find(params[:id])
    else
      @event = current_user.events.find(params[:id])
    end
    if @event.update event_params
      redirect_to :back,  notice: "Занятие изменено."
    else
      flash[:error] = t(@event.errors.messages.values.join(" "))
      redirect_to :back
    end
  end

  def edit
    @event = Event.find(params[:id])
    @product = Area.friendly.find @event.area_id
    if current_user.id == @event.user_id ||
        (current_user.type == "StadiumUser" && current_user.id == @product.stadium.user_id )
    else
      redirect_to :back,  notice: "Вы не можете редактировать это занятие"
    end
  end

  def for_sale
    @my_events = current_user.present? \
        ? current_user.events.includes(:area, :coach, :services).paid.future
        : []
    @events = Event.includes(:area, :coach, :services).future.for_sale
  end

  def show
    redirect_to :back, notice: "Занятие добавлено в корзину."
  end

  def ticket
    @event = Event.find(params[:id])
    render layout: "ticket"
  end

  def buy
    @event = Event.find(params[:id])
    transaction = ActiveRecord::Base.transaction do
      current_user.wallet.withdraw! @event.price
      @event.user.wallet.deposit! @event.price
      @event.update user: current_user, status: :paid
    end
    redirect_to for_sale_events_path, notice: "Заказ успешно куплен."
  end

  def destroy
    event = Event.find(params[:id])
    reason = params[:event][:reason]
    event.create_recoupment_if_cancelled reason
    event.destroy

    if event.paid?
      EventMailer.event_cancelled_mail(event, reason).deliver_now
      EventMailer.event_cancelled_notify_stadium(event, reason).deliver_now
      event.coach.present? && EventMailer.event_cancelled_notify_coach(event, reason).deliver_now
    elsif event.confirmed?
      EventMailer.confirmed_event_cancelled_mail(event, reason).deliver_now
      EventMailer.confirmed_event_cancelled_notify_stadium(event, reason).deliver_now
      event.coach.present? && EventMailer.confirmed_event_cancelled_notify_coach(event, reason).deliver_now
    end

    respond_to do |format|
      format.html {redirect_to :back, notice: "Успешно удален." }
      format.json {respond_with event}
    end
  end

  private

    def find_event

    end


     def event_params
      params.require(:event).permit(
        :id, :start, :stop, :area_id, :user_id, :coach_id, :is_all_day, :owned, :status, :reason,
         :recurrence_id, :recurrence_exception, :kind, :description,
        service_ids: [], recurrence_rule: []
      )
     end

    def current_product
      if params[:area_id].present?
        Area.friendly.find(params[:area_id])
      elsif params[:stadium_id].present?
        Stadium.friendly.find(params[:stadium_id]).areas.includes(:stadium)
      else
        current_user.events.map(&:area).uniq
      end
    end
end
