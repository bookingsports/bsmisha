# == Schema Information
#
# Table name: areas
#
#  id           :integer          not null, primary key
#  stadium_id   :integer
#  name         :string
#  description  :string
#  slug         :string
#  change_price :decimal(, )      default(0.0)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'rails_helper'

RSpec.describe Area do
  let(:stadium) { create(:stadium, name: 'Stadium') }
  let(:area) { create(:area, name: 'Main', stadium: stadium) }

  context 'associations' do
    it { should belong_to(:stadium) }
    it { should have_many(:coaches_areas) }
    it { should have_many(:coaches) }
    it { should have_many(:events) }
    it { should have_many(:prices).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:stadium_id) }
    it { should validate_numericality_of(:change_price).is_greater_than_or_equal_to(0) }
  end

  describe '#change_price' do
    it 'should return 0 by default' do
      area = Area.new
      expect(area.change_price).to eq 0
    end
  end

  describe '#display_name' do
    it 'returns the correct name' do
      expect(area.display_name).to eq "Stadium - Main"
    end
  end

  describe '#name_with_stadium' do
    it 'returns the correct name' do
      expect(area.name_with_stadium).to eq "Stadium - площадка Main"
    end
  end

  describe '#kendo_area_id' do
    it 'returns 0 when only 1 area is present' do
      stadium.areas = [area]
      expect(area.kendo_area_id).to eq 0
    end

    it 'returns 1 when 2 areas are present' do
      area_2 = create(:area)
      stadium.areas = [area, area_2]
      expect(area.kendo_area_id).to eq 0
      expect(area_2.kendo_area_id).to eq 1
    end

    it 'handles cases when there are more than 10 areas' do
      9.times {|n| stadium.areas << create(:area, name: "Area #{n}") } # 10 courts
      expect(stadium.areas.create(name: 'New area').kendo_area_id).to eq 0
    end
  end
end
