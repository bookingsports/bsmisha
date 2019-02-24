class MyEventsController < EventsController
  layout "dashboard"
  before_action :authenticate_user!

  def index
    @events = current_user.events
    @events_unconfirmed = @events.unpaid.future.unconfirmed.order(start: :asc).includes(:area, :coach, :event_change, :services)
    @events_confirmed = @events.unpaid.future.confirmed.order(start: :asc).includes(:area, :coach, :event_change, :services)
    @events_paid = @events.paid.future.order(start: :asc).includes(:area, :coach, :event_change, :services)

    @event_changes = current_user.event_changes.order(created_at: :desc).unpaid.future
    @recoupments = current_user.recoupments.where.not(price: 0)
    @discounts = current_user.discounts

    respond_to do |format|
      format.json { @events = @events.of_products([current_product]) }
      format.html {}
    end
  end

  def paid
    if current_user.kind_of? StadiumUser
      @events = current_user.stadium.events
    elsif current_user.kind_of? CoachUser
      @events = current_user.coach.events
    else
      redirect_to root_url
      return
    end

    @past_paid_events = @events.order(start: :desc).paid.includes(:area, :services, :coach).past
    @future_paid_events = @events.order(start: :desc).paid.includes(:area, :services, :coach).future
    @confirmed_events = @events.order(start: :desc).unpaid.confirmed.includes(:area, :services, :coach).future
  end

  def grid
  end

  # TODO: Check do we still need this action
  def bulk_process
  end

  def confirm
    if params[:event_ids].present?
      begin
        current_user.events.where(id: params[:event_ids]).each {|e| e.update! status: Event.statuses[:confirmed]}
      rescue => e
        return redirect_to my_events_url, alert: e.message
      end
      redirect_to my_events_url, notice: "Заказы успешно забронированы."
    else
      redirect_to my_events_url, alert: "Не выбрано ни одного заказа!"
    end
  end

  def pay_change
    @change = EventChange.find(params[:id])

    if @change.update status: :paid
      redirect_to my_events_url, notice: "Перенос успешно подтвержден."
    else
      redirect_to my_events_url, notice: "Ошибка сервера."
    end
  end

  def sell
    @event = Event.find(params[:id])

    @event.update status: :for_sale
    redirect_to :back, notice: "Заказ выставлен на продажу."
  end

  def overpay
    if params[:value].blank? || (params[:value].to_i > 0 && params[:value].to_i < 10)
      @overpayed = 0
    elsif (params[:value].to_i >= 10 && params[:value].to_i <= 30)
      @overpayed = 30.minutes
    else
      @overpayed = params[:value].to_i.minutes
    end

    @event = Event.find(params[:id])

    if @overpayed > 0 && (@event.stop + @overpayed).to_date == @event.stop.to_date
      old_price = @event.price
      @event.update_column('stop', @event.stop + @overpayed)
      @event.user.wallet.withdrawals.create amount: @event.price - old_price
      @event.area.stadium.user.wallet.deposits.create amount: @event.price - old_price
    end

    EventMailer.event_overpayed(@event, @overpayed, @event.price - old_price).deliver_now

    redirect_to paid_my_events_path
  end

  def destroy
    if params[:event_ids].present? || params[:event_change_ids].present?
      params[:event_ids].present? && current_user.events.unpaid.where(id: params[:event_ids]).each do |event|
        if event.confirmed?
          EventMailer.confirmed_event_cancelled_notify_stadium(event, "Заказ удален пользователем").deliver_now
          event.coach.present? && EventMailer.confirmed_event_cancelled_notify_coach(event, "Заказ удален пользователем").deliver_now
        end
        event.destroy
      end
      params[:event_change_ids].present? && current_user.event_changes.unpaid.where(id: params[:event_change_ids]).destroy_all
      redirect_to my_events_path, notice: "Успешно удалены."
    else
      redirect_to my_events_path, alert: "Не выбрано ни одного заказа!"
    end
  end

  def confirm_pay
    if params[:event_ids].blank? && params[:event_change_ids].blank?
      redirect_to my_events_url, alert: "Не выбрано ни одного заказа"
      return
    end
    @event_ids = params[:event_ids]
    @events = Event.where(id: params[:event_ids])
    @event_changes = EventChange.where(id: params[:event_change_ids])
    @area_ids = (@events.map(&:area_id) + @event_changes.map{|e| e.event.area_id}).uniq
    @recoupments = current_user.recoupments.where(area: @area_ids)
    @discounts = current_user.discounts.where(area: @area_ids).includes(:area)
    @signature = PayuService.new(@event_ids).send_params
    @total = @events.map{|e| e.price *
          (@discounts.where(area_id: e.area_id).present? ? @discounts.where(area_id: e.area_id).first.percent : 1) }.inject(:+).to_i +
          @event_changes.map{|e| e.total *
          (@discounts.where(area_id: e.event.area_id).present? ? @discounts.where(area: e.event.area_id).first.percent : 1) }.inject(:+).to_i -
          current_user.recoupments.where(area: @area_ids).uniq.map(&:price).sum
  end

  def pay
    @events = Event.where(id: params[:event_ids])
    @event_changes = EventChange.where(id: params[:event_change_ids])

    ActiveRecord::Base.transaction do
      @events.each(&:pay!)
      @event_changes.each(&:pay!)
    end

    if @events.map(&:errors).map(&:full_messages).flatten.any?
      redirect_to my_events_path, alert: "Возникли ошибки: " + @events.map(&:errors).map(&:full_messages).join(", ")
    end
  end
end
