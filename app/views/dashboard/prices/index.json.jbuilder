json.array!(@dashboard_special_prices) do |dashboard_special_price|
  json.extract! dashboard_special_price, :id, :start, :end, :price, :is_sale, :area_id
  json.url dashboard_special_price_url(dashboard_special_price, format: :json)
end
