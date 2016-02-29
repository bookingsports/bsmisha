# == Schema Information
#
# Table name: stadiums
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string
#  phone       :string
#  description :string
#  address     :string
#  latitude    :float
#  longitude   :float
#  slug        :string
#  status      :integer
#  email       :string
#  avatar      :string
#  opens_at    :time
#  closes_at   :time
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
