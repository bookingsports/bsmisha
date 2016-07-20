class MyEventsController < EventsController
  layout "dashboard"
  before_action :authenticate_user!

  def index
    @events = current_user.events
    @events_unconfirmed = @events.unpaid.future.unconfirmed.order(start: :asc).includes(:area, :coach, :event_change, :stadium_services)
    @events_confirmed = @events.unpaid.future.confirmed.includes(:area, :coach, :event_change, :stadium_services)
    @events_paid = @events.paid.future.includes(:area, :coach, :event_change, :stadium_services)

    @event_changes = current_user.event_changes.order(created_at: :desc).unpaid.future
    @recoupments = current_user.recoupments.where.not(price: 0)

    respond_to do |format|
      format.json { @events = @events.of_products([current_product]) }
      format.html {}
    end
  end

  def paid
    if current_user.kind_of? StadiumUser
      @events = current_user.stadium.events
    else
      @events = current_user.coach.events
    end
    @paid_events = @events.order(start: :desc).paid.includes(:area, :stadium_services, :coach)
    @confirmed_events = @events.order(start: :desc).unpaid.confirmed.includes(:area, :stadium_services, :coach, :order)
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
      rescue
        return redirect_to my_events_url, alert: "Произошла ошибка. Скорее всего, данное время уже занято."
      end
      redirect_to my_events_url, notice: "Заказы успешно забронированы."
    else
      redirect_to my_events_url, alert: "Не выбрано ни одного заказа!"
    end
  end

  def pay_change
    @change = EventChange.find(params[:id])

    if @change.update order: Order.create(status: :paid)
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



    redirect_to paid_my_events_path
  end

  def destroy
    if params[:event_ids].present? || params[:event_change_ids].present?
      params[:event_ids].present? && current_user.events.unpaid.where(id: params[:event_ids]).destroy_all
      params[:event_change_ids].present? && current_user.event_changes.unpaid.where(id: params[:event_change_ids]).destroy_all
      redirect_to my_events_path, notice: "Успешно удалены."
    else
      redirect_to my_events_path, alert: "Не выбрано ни одного заказа!"
    end
  end
end
