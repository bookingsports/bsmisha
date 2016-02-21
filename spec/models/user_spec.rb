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
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string
#  role                   :integer
#  type                   :string
#  slug                   :string
#  avatar                 :string
#  status                 :integer
#  phone                  :string
#

require 'rails_helper'

Rspec.describe User do
  before(:each) do
    @user = User.new(email: "user@example.com")
    @valid_user = create(:user)
  end

  subject { @user }

  it { should respond_to(:email) }

  it "#email returns a string" do
    expect(@user.email).to match("user@example.com")
  end

  it "#wallet returns a Wallet object" do
    expect(@valid_user.wallet).to be_an_instance_of(Wallet)
  end
end
