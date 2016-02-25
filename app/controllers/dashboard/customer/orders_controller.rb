class Dashboard::Customer::OrdersController < DashboardController
  before_filter :authenticate_user!
  respond_to :html, :json, :js

  def index
    @orders = current_user.orders.order("created_at desc")
  end

  def new
    @order = Order.new user: current_user
    @order.events.new start: DateTime.parse(params[:start]), end: DateTime.parse(params[:end]), court_id: params[:court]
  end

  def show
    @order = Order.find params[:id]
  end

  def pay
    @order = Order.find(params[:id])
    transaction = ActiveRecord::Base.transaction do
      @order.events.each do |event|
        if current_user.wallet.withdraw!(event.total)
          event.court.stadium.owner.wallet.deposit!(event.dry_court_total)
          event.additional_event_items.each do |ai|
            ai.payment_receiver.wallet.deposit! ai.total
          end
        else
          redirect_to(dashboard_orders_path, alert: "Недостаточно средств")
          raise ActiveRecord::Rollback
        end
      end
      @order.event_changes.each do |change|
        change.event.update JSON.parse(change.summary)
        if current_user.wallet.withdraw!(change.total)
          change.event.court.stadium.owner.wallet.deposit!(change.total)
        else
          redirect_to(dashboard_orders_path, alert: "Недостаточно средств")
          raise ActiveRecord::Rollback
        end
      end
    end

    if transaction
      @order.status = "paid"
      @order.save
      respond_with @order, notice: 'Заказ успешно оплачен'
    end
  end

  def destroy
    @order = Order.find params[:id]
    if @order.unpaid? && @order.destroy
      redirect_to dashboard_orders_path, notice: 'Заказ успешно удален'
    else
      redirect_to dashboard_orders_path, alert: 'Заказ не удалось удалить'
    end
  end

  def total
  end
end
