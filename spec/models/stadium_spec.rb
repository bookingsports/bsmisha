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

describe Stadium do
  before(:each) do
    @stadium = create(:stadium, name: "Stadium")
  end

  it { should belong_to(:user) }
  it { should belong_to(:category) }
  it { should have_many(:areas) }
  #it { should have_many(:events) }
  it { should have_many(:pictures) }
  it { should have_many(:reviews) }
  it { should have_many(:stadium_services) }
  it { should have_many(:services) }

  describe ".account" do
    it "is created when new Stadium is created" do
      expect(@stadium.account).not_to be_nil
    end
  end

  describe ".areas" do
    it "one area is created when new Stadium is created" do
      expect(@stadium.areas.count).to eq 1
    end
  end

  describe ".status" do
    it "is :pending by default" do
      expect(@stadium.status).to eq "pending"
    end
  end

  describe "#name" do
    it "returns name when it is not set" do
      expect(Stadium.create.name).to eq "Без названия"
    end

    it "returns name when it is set" do
      expect(@stadium.name).to eq "Stadium"
    end
  end

  context "address parsing" do
    it "should update lattitude and longitude after saving a stadium" do
      stadium = Stadium.new(address: "Бишкек, ул. Московская, 21")

      expect {
        stadium.save
      }.to change { stadium.latitude }.and change { stadium.longitude }
    end
  end
end
