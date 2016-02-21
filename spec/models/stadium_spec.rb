# == Schema Information
#
# Table name: products
#
#  id           :integer          not null, primary key
#  category_id  :integer
#  user_id      :integer
#  name         :string
#  phone        :string
#  description  :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  address      :string
#  latitude     :float            default(55.75)
#  longitude    :float            default(37.61)
#  slug         :string
#  status       :integer          default(0)
#  type         :string
#  parent_id    :integer
#  email        :string
#  avatar       :string
#  price        :decimal(8, 2)
#  change_price :decimal(8, 2)
#  opens_at     :datetime
#  closes_at    :datetime
#

require 'rails_helper'

RSpec.describe Stadium do
  context "address parsing" do
    it "should update lattitude and longitude after saving a stadium" do
      stadium = Stadium.new(address: "Бишкек, ул. Московская, 21")

      expect {
        stadium.save
      }.to change { stadium.latitude }.and change { stadium.longitude }
    end
  end
end
