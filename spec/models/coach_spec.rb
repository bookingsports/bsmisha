# == Schema Information
#
# Table name: stadiums
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  category_id :integer
#  name        :string           default("Без названия"), not null
#  phone       :string
#  description :string
#  address     :string
#  latitude    :float
#  longitude   :float
#  slug        :string
#  status      :integer          default(0)
#  email       :string
#  avatar      :string
#  opens_at    :time
#  closes_at   :time
#  created_at  :datetime
#  updated_at  :datetime
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

  describe "#account" do
    it "should be created on initialize" do
      expect(@coach.account).not_to be_nil
    end
  end

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
