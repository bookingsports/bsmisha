# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  name                   :string
#  type                   :string           default("Customer")
#  avatar                 :string
#  status                 :integer          default(0)
#  phone                  :string
#  created_at             :datetime
#  updated_at             :datetime
#

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
