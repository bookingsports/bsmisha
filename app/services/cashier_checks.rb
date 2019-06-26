require 'net/http'
require 'uri'
require 'json'

class CashierChecks

  def initialize(order,type)
    @order = order
    @type = type
    @user = User.find(@order.user_id)
  end

  def send_params
    return unless @order.present?
    payment_data.merge(order_data)
  end

  def send_request
    uri = URI.parse("https://app.ekam.ru/api/online/v2/receipt_requests")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request["Accept"] = "application/json"
    request["X-Access-Token"] = Rails.application.secrets.ekam_token
    request.body = send_params.to_json
    puts request.body
    req_options = {
        use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      puts "in"
      http.request(request)
    end
  end

  private

  def payment_data
    {

    type:	@type,
        #One of SaleReceiptRequest ReturnReceiptRequest
    cash_amount:	0,
    electron_amount:	@order.subtotal,
    email:	@user.email,
    phone_number:	@user.phone,
    should_print:	false,
    order_id:	@order.id,
    cashier_name:	"Яковлев Вадим",
    draft: "false",
    }
  end

  def order_data
    order_data = {lines: []}
    @order.order_items.each do |oi|
      order_item_data(oi)
      order_data[:lines].push(order_item_data(oi).merge(agent_data(oi)))
    end
    return order_data
  end

  def order_item_data(order_item)
    {
        price: order_item.unit_price,
        quantity:	order_item.quantity,
        title:	"Занятие спортом",
        total_price:	order_item.total_price,
        vat_rate: nil,
        fiscal_product_type:	4,
        payment_case:	1
    }
  end

  def agent_data(order_item)
    agent_data= {
        agent_type:	5,
        agent_name:	nil,
        agent_phone: nil,
        agent_inn: nil,
    }
    if order_item.event_id.present?
      agent_data[:agent_name] = order_item.event.area.stadium.account.company
      agent_data[:agent_phone] = order_item.event.area.stadium.phone
      agent_data[:agent_inn] = order_item.event.area.stadium.account.inn
    elsif order_item.group_event_id.present?
      agent_data[:agent_name] = order_item.group_event.area.stadium.account.company
      agent_data[:agent_phone] = order_item.group_event.area.stadium.phone
      agent_data[:agent_inn] = order_item.group_event.area.stadium.account.inn
    elsif order_item.event_change_id.present?
      agent_data[:agent_name] = order_item.event_change.event.area.stadium.account.company
      agent_data[:agent_phone] = order_item.event_change.event.area.stadium.phone
      agent_data[:agent_inn] = order_item.event_change.event.area.stadium.account.inn
    end
    return agent_data
  end
end