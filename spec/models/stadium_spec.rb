require 'rails_helper'

RSpec.describe Stadium, type: :model do
  context "address parsing" do
    it "should update lattitude and longitude after saving a stadium" do
      stadium = Stadium.new(address: "Бишкек, ул. Московская, 21")

      expect {
        stadium.save
      }.to change { stadium.latitude }.and change { stadium.longitude }
    end
  end
end
