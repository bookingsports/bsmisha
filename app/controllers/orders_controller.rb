# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  total      :decimal(8, 2)
#  status     :integer          default(0)
#  comment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class OrdersController < DashboardController
  before_filter :authenticate_user!
  respond_to :json, :js, :html

  def index
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = current_user.orders.new
    @order.events = Event.find(params[:event_ids]) if params[:event_ids]
    @order.event_changes = EventChange.find(params[:event_change_ids]) if params[:event_change_ids]

    @order.save!

    respond_with @order
  end

  def pay
    @order = Order.find(params[:id])
    @order.pay!

    respond_with @order
  end

end
