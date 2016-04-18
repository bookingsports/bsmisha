require 'rails_helper'

RSpec.feature "dashboard" do

  let(:stadium_user) {create(:stadium_user)}
  let(:area) {stadium_user.stadium.areas.first}
  let(:category) {Category.create!(name: "Футбол")}

  before(:each) do
    signin(stadium_user.email, stadium_user.password)
  end

  describe "coaches section" do
    context "displaying coaches" do
      let(:another_stadium_user) {create(:stadium_user)}
      let(:another_area) {another_stadium_user.stadium.areas.first}

      it "doesn't display other stadiums' coaches" do
        coach_user = create(:coach_user)
        coaches_area = coach_user.coach.coaches_areas.create area: another_area, price: 100, stadium_percent: 30

        visit dashboard_coach_users_path
        expect(page).not_to have_content coach_user.name
      end

      it "displays this stadium's coaches" do
        coach_user = create(:coach_user)
        coaches_area = coach_user.coach.coaches_areas.create area: area, price: 100, stadium_percent: 30

        visit dashboard_coach_users_path
        expect(page).to have_content coach_user.name
      end
    end

    context "editing coaches" do
      it "lets you confirm coaches" do
        coach_user = create(:coach_user, name: "Антон")
        coaches_area = coach_user.coach.coaches_areas.create area: area, price: 100, stadium_percent: 30, status: :pending

        visit dashboard_coach_users_path
        click_link "Подтвердить"
        expect(coaches_area.reload.status).to eq "active"
      end

      it "lets you block coaches" do
        coach_user = create(:coach_user, name: "Антон")
        coaches_area = coach_user.coach.coaches_areas.create area: area, price: 100, stadium_percent: 30, status: :active

        visit dashboard_coach_users_path
        click_link "Заблокировать"
        expect(coaches_area.reload.status).to eq "locked"
      end
    end

    it "lets you unblock coaches" do
      coach_user = create(:coach_user, name: "Антон")
      coaches_area = coach_user.coach.coaches_areas.create area: area, price: 100, stadium_percent: 30, status: :locked

      visit dashboard_coach_users_path
      click_link "Разблокировать"
      expect(coaches_area.reload.status).to eq "active"
    end
  end
=begin
  describe "areas section" do
    it "edits area" do
      visit edit_dashboard_product_path
      # puts page.html
      within ".areas" do
        fill_in "product_areas_attributes_0_name", with: "Name"
        fill_in "product_areas_attributes_0_price", with: 100
        fill_in "product_areas_attributes_0_change_price", with: 10
        select "Футбол", from: "product_areas_attributes_0_category_id"
      end

      click_button "Сохранить стадион"

      area.reload

      expect(area.name).to eq("Name")
      expect(area.category.name).to eq("Футбол")
    end
  end
=end
end
