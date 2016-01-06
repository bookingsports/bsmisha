class Dashboard::OrdersController < DashboardController
  def index
    @orders = current_user.stadium.events
  end

  def update
    @order = Order.find params[:id]
    @order.update order_params

    redirect_to dashboard_orders_path, notice: "Статус заказа изменен"
  end

  private

    def order_params
      params.require(:order).permit(:status, :comment)
    end
end
