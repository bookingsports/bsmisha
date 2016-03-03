# == Schema Information
#
# Table name: prices
#
#  id         :integer          not null, primary key
#  start      :datetime
#  stop       :datetime
#  price      :integer
#  is_sale    :boolean
#  area_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Price < ActiveRecord::Base
  include PriceConcern

  has_paper_trail

  belongs_to :product
  has_many :daily_price_rules, dependent: :destroy
  accepts_nested_attributes_for :daily_price_rules, reject_if: proc {|attributes| attributes["price"].blank?}

  # return price for current time
  scope :current, -> do
    where('LOCALTIMESTAMP BETWEEN "start" AND "stop"').last || new
  end

  def name
    "Период с #{start} по #{stop}"
  end

  def duration
    self.end - start
  end

  def price options={}
    hour = options.delete(:hour)
    event = options.delete(:event)
    price_rules = if event
      daily_price_rules.where("? = ANY(working_days) and (?::time >= start::time and ?::time < stop::time)", event.start.wday, "#{hour}:00", "#{hour}:00")
    else
      []
    end

    if price_rules.any?
      price_rules.first.price
    else
      attributes["price"]
    end
  end
end
