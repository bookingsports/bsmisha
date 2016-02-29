# == Schema Information
#
# Table name: areas
#
#  id           :integer          not null, primary key
#  stadium_id   :integer
#  name         :string
#  description  :string
#  slug         :string
#  price        :decimal(, )      default(0.0)
#  change_price :decimal(, )      default(0.0)
#  opens_at     :time
#  closes_at    :time
#  created_at   :datetime
#  updated_at   :datetime
#

require 'rails_helper'

describe Area, type: :model  do
  it { should belong_to(:stadium) }
  it { should have_many(:coaches_areas) }
  it { should have_many(:coaches) }

  before(:each) do
    @stadium = create(:stadium, name: "Stadium")
    @area = @stadium.areas.first
    @area.update name: "Main"
  end

  describe ".price" do
    it "should return 0 by default" do
      expect(@area.price).to eq 0
    end
  end

  describe ".change_price" do
    it "should return 0 by default" do
      expect(@area.change_price).to eq 0
    end
  end

  describe "#display_name" do
    it "returns the correct name" do
      expect(@area.display_name).to eq "Stadium - Main"
    end
  end

  describe "#name_with_stadium" do
    it "returns the correct name" do
      expect(@area.name_with_stadium).to eq "Stadium - площадка Main"
    end
  end

  describe "#kendo_area_id" do
    it "returns 0 when only 1 court is present" do
      expect(@area.kendo_area_id).to eq 0
    end

    it "returns 1 when 2 courts are present" do
      @area2 = @stadium.areas.create name: "Second"
      expect(@area.kendo_area_id).to eq 0
      expect(@area2.kendo_area_id).to eq 1
    end

    it "handles cases when there are more than 10 courts" do
      9.times {|n| @stadium.areas.create name: "Area #{n}" } # 10 courts
      expect(@stadium.areas.create(name: "New area").kendo_area_id).to eq 0
    end
  end
end
