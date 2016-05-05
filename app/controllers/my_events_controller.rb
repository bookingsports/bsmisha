class MyEventsController < EventsController
  layout "dashboard"
  before_action :authenticate_user!

  def index
    @events = current_user.events.order(created_at: :desc)
    @event_changes = current_user.event_changes.order(created_at: :desc)
    @recoupments = current_user.recoupments.where.not(price: 0)

    respond_to do |format|
      format.json { @events = @events.of_products([current_product]) }
      format.html {}
    end
  end

  def paid
    @events = (current_user.kind_of? StadiumUser) ? current_user.stadium.events.order(created_at: :desc) : current_user.coach.events.order(created_at: :desc)
  end

  def grid
  end

  # TODO: Check do we still need this action
  def bulk_process
  end

  def confirm
    if params[:event_ids].present?
      current_user.events.where(id: params[:event_ids]).update_all status: Event.statuses[:confirmed]
      redirect_to my_events_path, notice: "Заказы успешно забронированы."
    else
      redirect_to my_events_path, alert: "Не выбрано ни одного заказа!"
    end
  end

  def pay_change
    @change = EventChange.find(params[:id])

    if @change.update order: Order.create(status: :paid)
      redirect_to my_events_path, notice: "Перенос успешно подтвержден."
    else
      redirect_to my_events_path, notice: "Ошибка сервера."
    end
  end

  def sell
    @event = Event.find(params[:id])

    @event.destroy
    redirect_to my_events_path
  end

  def overpay
    if params[:value].blank? || (params[:value].to_i > 0 && params[:value].to_i <= 10)
      @overpayed = 0
    elsif (params[:value].to_i > 10 && params[:value].to_i <= 30)
      @overpayed = 30.minutes
    else
      @overpayed = params[:value].to_i.minutes
    end

    @event = Event.find(params[:id])
    old_price = @event.price
    @event.update_attribute('stop', @event.stop + @overpayed)
    @event.user.wallet.withdrawals.create amount: @event.price - old_price
    @event.area.stadium.user.wallet.deposits.create amount: @event.price - old_price

    redirect_to paid_my_events_path
  end

  def destroy
    if params[:event_ids].present?
      current_user.events.unpaid.where(id: params[:event_ids]).destroy_all
      redirect_to my_events_path, notice: "Успешно удалены."
    else
      redirect_to my_events_path, alert: "Не выбрано ни одного заказа!"
    end
  end
end
