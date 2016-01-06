class Customer < User
  def products
    Product.where(id: events.map(&:product_ids).flatten)
  end
end
