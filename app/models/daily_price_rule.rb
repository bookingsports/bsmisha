class DailyPriceRule < ActiveRecord::Base
  belongs_to :special_price

  def start=(val)
    string = val.kind_of?(String) ? val : val.values.join(":")
    super(string)
  end

  def stop=(val)
    string = val.kind_of?(String) ? val : val.values.join(":")
    super(string)
  end
end
