# == Schema Information
#
# Table name: stadium_services
#
#  id         :integer          not null, primary key
#  stadium_id :integer
#  service_id :integer
#  price      :float
#  periodic   :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe StadiumService do
  before(:each) do
    @stadium_user = create(:stadium_user)
    @stadium = @stadium_user.stadium
    @stadium.update(name: "Stadium")
    @service = create(:service, name: "Service")
    @stadium_service = @stadium.stadium_services.create service: @service
  end

  it { should belong_to(:stadium) }
  it { should belong_to(:service) }
  it { should have_and_belong_to_many(:events) }

  describe ".user" do
    it "should be delegated to stadium" do
      expect(@stadium_service.user).to eq @stadium_user
    end
  end

  describe "#name" do
    it "should return proper name" do
      expect(@stadium_service.name).to eq "Услуга Service стадиона Stadium"
    end
  end
end
