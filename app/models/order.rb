class Order < ActiveRecord::Base
  has_many :order_items
  has_many :events, :through => :order_items
  has_many :group_events, :through => :order_items
  has_many :event_changes, :through => :order_items

  before_save :update_subtotal

  enum status: [:unconfirmed, :confirmed, :paid, :paid_approved, :canceled]

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
  end

  def update_status (status)
    self.update status: status
    self.order_items.each{|e| e.update_status(status)}
  end

  def check_registration_request_data (type)
    user = User.find(self.user_id)
    request =
        {
        "order_id": id,
        "order_number": id,
        "type": type,
        "email": user.email,
        "phone_number": user.phone,
        "should_print": false,
        "cash_amount": 0,
        "electron_amount": self.total.to_int,
        "prepaid_amount": 0,
        "postpaid_amount": 0,
        "counter_offer_amount": 0,
        "cashier_name": "booking",
        "draft": true,
        "lines": [
            {
                "price": 10,
                "quantity": 2,
                "title": "Плюшевый мишка",
                "total_price": 20,
                "fiscal_product_type": 0,
                "payment_case": 0
            }
        ]

    }
    return request
  end
  private

  def update_subtotal
    self[:subtotal] = subtotal
  end
end