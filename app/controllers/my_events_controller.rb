class MyEventsController < EventsController
  layout "dashboard"

  def index
    @events = current_user.events.order(created_at: :desc)

    respond_to do |format|
      format.json { @events = @events.of_products(current_products) }
      format.html {}
    end
  end

  def paid
    @events = current_user.product.events.order(created_at: :desc)
  end

  def grid
  end

  # TODO: Check do we still need this action
  def bulk_process
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
