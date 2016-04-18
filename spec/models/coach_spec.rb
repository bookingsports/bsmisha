# == Schema Information
#
# Table name: coaches
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  slug        :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Coach do
  before(:each) do
    @coach_user = create(:coach_user, name: "Coach")
    @coach = @coach_user.coach
    @coach.update description: "Description"
  end

  it { should belong_to(:user) }
  it { should have_many(:coaches_areas) }
  it { should have_many(:areas) }
  it { should have_one(:account) }

  describe "#name" do
    it "should be delegated to user" do
      expect(@coach.name).to eq "Coach"
    end
  end

  describe "#has_areas" do
    it "should return 0 when no areas is present" do
      expect(@coach.has_areas?).to eq false
    end
  end
end
