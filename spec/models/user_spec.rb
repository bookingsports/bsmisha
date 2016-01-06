describe User do
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
