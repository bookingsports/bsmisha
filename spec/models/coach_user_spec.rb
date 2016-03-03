require 'rails_helper'

describe CoachUser do
  before(:each) do
    @coach_user = create(:coach_user, name: "Coach")
  end

  it { should have_one(:coach) }

  describe "#coach" do
    it "should be created on initialize" do
      expect(@coach_user.coach).not_to be_nil
    end
  end
end
