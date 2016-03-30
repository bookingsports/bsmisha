require 'rails_helper'

RSpec.feature "dashboard" do

  let(:stadium_user) {create(:stadium_user)}
  let(:area) {stadium_user.stadium.areas.first}
  let(:category) {Category.create!(name: "Футбол")}

  before(:each) do
    signin(stadium_user.email, stadium_user.password)
  end

  describe "coaches section" do
    it "lets you create coach" do
      visit dashboard_coach_users_path
      click_link "Создать тренера"

      fill_in "Имя", with: "Имя"
      fill_in "Эл. почта", with: "test_coach@example.com"
      fill_in "Пароль", with: "123123123"
      fill_in "Подтверждение пароля", with: "123123123"

      # click_link "Добавить"

      expect{ click_button "Сохранить" }.to change(CoachUser, :count).by 1
      expect(page).to have_text CoachUser.last.coach.name
    end

    it "lets you edit coach" do
      coach_user = create(:coach_user, name: "Антон")
      coach_user.coach.coaches_areas.create area: area, price: 100

      visit dashboard_coach_users_path
      click_link "Редактировать"
      fill_in "Имя", with: "Антонбей"
      click_button "Сохранить"

      expect(area.coaches.last.name).to eq("Антонбей")
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
