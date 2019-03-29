class GroupEventsController < ApplicationController
  respond_to :json, :html
  before_filter :authenticate_user!, except: [:index, :new, :parents_events, :one_day]

  def index
    @stadium = params[:stadium].present? ? Stadium.friendly.find(params[:stadium]) : Stadium.active.first
    if params[:from] == "one_day" && params[:areas].present?
      @group_events = GroupEvent.scoped_by(area: Area.where(slug: params[:areas]), user: nil)
    elsif params[:from] == "one_day"
      @group_events = []
    elsif params[:scope] == "coach"
      @group_events = GroupEvent.scoped_by(coach: Coach.friendly.find(params[:coach_id]), area: current_product, user: current_user)
    elsif params[:scope] == "grid" && current_user.present? && current_user.type == "CoachUser"
      @group_events = GroupEvent.scoped_by(area: current_user.areas, user: current_user, coach: current_user.coach, scope: params[:scope])
    elsif current_user.present? && params[:area_id].present? && current_user.type == "StadiumUser"
      @group_events = GroupEvent.scoped_by(area: current_product, user: current_user, scope: params[:scope])
    elsif current_user.present? && current_user.type == "StadiumUser"
      @group_events = GroupEvent.scoped_by(area: current_user.areas, user: current_user, scope: params[:scope])
    elsif params[:stadium].present?
      @group_events = GroupEvent.scoped_by(area: @stadium.areas)
    else
      @group_events = GroupEvent.scoped_by(user: current_user, area: current_product, scope: params[:scope])
    end
    respond_with @group_events
  end

  def new
    if params[:area_id].present?
      @product = Area.friendly.find params[:area_id]
      if @product.coaches_areas.any?
        @coaches = @product.coaches_areas
      end
    end
    @group_event = GroupEvent.new
  end

  def parents_events
    if params[:scope] == "stadium"
      stadium = Stadium.friendly.find(params[:stadium_id])
      if current_user.present?
        @group_events = stadium.areas.flat_map {|area| current_user.events.where(area: area)}
      else
        @group_events = []
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
    @group_event = current_user.group_events.create group_event_params.delete_if {|k,v| v.empty? }

    if @group_event.recurring?
      @group_events = GroupEvent.split_recurring @group_event
      t = ActiveRecord::Base.transaction { @group_events.each(&:save) }
      errors = @group_events.map(&:errors).map(&:messages).select(&:present?)
      if errors.blank?
        respond_with @group_events
      else
        render json: { error: errors.map(&:values).join(", ") }
      end
    else
      if current_user.type == "StadiumUser" && current_user.stadium.areas.include?(@group_event.area)
        @group_event.status = :locked
      end
      if @group_event.save
        respond_with @group_event
      else
        flash[:error] = t(@group_event.errors.messages.values.join(" "))
        redirect_to :back
      end
    end
  end

  def update
    if current_user.present?
      @group_event = GroupEvent.find(params[:id])
      @product = Area.friendly.find @group_event.area_id

      if current_user.id == @product.stadium.user_id || @product.stadium.is_stadium_coach(current_user.id)
        if @group_event.update group_event_params
          redirect_to :back,  notice: "Изменения успешно сохранены."
        else
          redirect_to :back, notice: event_guest.errors.messages.values.join(" ")
        end
      else
        event_guest = @group_event.event_guests.new(:start=> @group_event.start,:stop=> @group_event.stop,
                                                    :email => current_user.email, :name => current_user.name)
        if event_guest.save
          redirect_to :back,  notice: "Вы записаны на занятие."
        else
          redirect_to :back, notice: event_guest.errors.messages.values.join(" ")
        end
      end
    end
  end

  def edit
    @group_event = GroupEvent.find(params[:id])
    @product = Area.friendly.find @group_event.area_id
  end

  def for_sale
    @my_events = current_user.present? \
        ? current_user.events.includes(:area, :coach, :services).paid.future
        : []
    @events = Event.includes(:area, :coach, :services).future.for_sale
  end

  def show
    redirect_to :back, notice: "Занятие создано."
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


     def group_event_params
      params.require(:group_event).permit(
        :id, :start, :stop, :area_id, :user_id, :coach_id, :is_all_day, :status, :name,
        :price, :recurrence_rule, :recurrence_id, :recurrence_exception, :kind, :description,:max_count_participants,
        service_ids: []
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
