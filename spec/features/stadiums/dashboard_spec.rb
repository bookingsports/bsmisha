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

  describe "stadium editing" do
    it "should fail when area name is not set" do
      visit edit_dashboard_product_path
      fill_in "product_areas_attributes_0_name", with: ""
      click_button "Сохранить стадион"

      expect(page).to have_content "Были введены неверные данные"
    end

    it "should fail when area's change price is not set" do
      visit edit_dashboard_product_path
      fill_in "product_areas_attributes_0_change_price", with: ""
      click_button "Сохранить стадион"

      expect(page).to have_content "Были введены неверные данные"
    end

    it "should fail when area's change price is less than 0" do
      visit edit_dashboard_product_path
      fill_in "product_areas_attributes_0_change_price", with: "-5"
      click_button "Сохранить стадион"

      expect(page).to have_content "Были введены неверные данные"
    end

    it "should fail when area's change price is more than 100" do
      visit edit_dashboard_product_path
      fill_in "product_areas_attributes_0_change_price", with: "300"
      click_button "Сохранить стадион"

      expect(page).to have_content "Были введены неверные данные"
    end

    it "should fail when deleting area that has events" do
      event = create(:event, area: area)
      visit edit_dashboard_product_path
      page.find("#product_areas_attributes_0__destroy").click
      click_button "Сохранить стадион"

      expect(page).to have_content "Нельзя удалить площадку, у которой еще есть заказы"
    end

    context "prices editing" do
      before(:each) do
        visit edit_dashboard_product_path
        click "Настроить цены"
        click "Редактировать"

        it "displays an error if a price is not set" do
          fill_in "price_daily_price_rules_attributes_0_value", with: ""
          click "Сохранить период"
          expect(page).to have_content "Были введены неверные данные"
        end

        it "prevents overlapping dailyprice rules when working days are overlapping" do
          check "#price_daily_price_rules_attributes_0_working_days_1"
          fill_in "price_daily_price_rules_attributes_0_value", with: "300"
          click "Добавить правило"
          check "#price_daily_price_rules_attributes_1_working_days_1"
          fill_in "price_daily_price_rules_attributes_1_value", with: "300"
          click "Сохранить период"

          expect(page).to have_content "Правила накладываются друг на друга"
        end

        it "prevents overlapping dailyprice rules" do
          check "#price_daily_price_rules_attributes_0_working_days_1"
          fill_in "price_daily_price_rules_attributes_0_value", with: "300"
          click "Добавить правило"
          check "#price_daily_price_rules_attributes_1_working_days_1"
          fill_in "price_daily_price_rules_attributes_1_value", with: "300"
          click "Сохранить период"

          expect(page).to have_content "Правила накладываются друг на друга"
        end
      end
    end
  end

  describe "orders listing" do

  end

  describe "withdrawing money" do
    it "should display an error when some of account's fields are not set" do
      stadium_user.wallet.deposits.create amount: 5000

      visit dashboard_withdrawal_requests_path
      fill_in "withdrawal_request_amount", with: 3000
      click_button "Перейти к выводу"
      expect(page).to have_content "Не все реквизиты заполнены!"
    end

    it "should not add a withdrawal with negative amount" do
      stadium_user.wallet.deposits.create amount: 5000
      stadium_user.stadium.account.update(number: "30101810200000000700", company: "АО “Райффайзенбанк”, 129090, Россия, г. Москва, ул. Троицкая, д.17/1", inn: "7744000302", kpp: "775001001", bik: "044525700", agreement_number: "1234567890", date: Time.now)

      visit dashboard_withdrawal_requests_path
      fill_in "withdrawal_request_amount", with: -5000
      click_button "Перейти к выводу"
      expect(page).to have_selector('table tbody tr', :count => 0)
    end

    it "should not add a withdrawal with amount more than amount limit" do
      stadium_user.wallet.deposits.create amount: 5000
      stadium_user.stadium.account.update(number: "30101810200000000700", company: "АО “Райффайзенбанк”, 129090, Россия, г. Москва, ул. Троицкая, д.17/1", inn: "7744000302", kpp: "775001001", bik: "044525700", agreement_number: "1234567890", date: Time.now)

      visit dashboard_withdrawal_requests_path
      fill_in "withdrawal_request_amount", with: 50000
      click_button "Перейти к выводу"
      expect(page).to have_selector('table tbody tr', :count => 0)
    end

    it "should not add a withdrawal with amount more than user's total" do
      stadium_user.wallet.deposits.create amount: 5000
      stadium_user.stadium.account.update(number: "30101810200000000700", company: "АО “Райффайзенбанк”, 129090, Россия, г. Москва, ул. Троицкая, д.17/1", inn: "7744000302", kpp: "775001001", bik: "044525700", agreement_number: "1234567890", date: Time.now)

      visit dashboard_withdrawal_requests_path
      fill_in "withdrawal_request_amount", with: 10000
      click_button "Перейти к выводу"
      expect(page).to have_selector('table tbody tr', :count => 0)
    end

    it "should not display an error when all fields are set" do
      stadium_user.wallet.deposits.create amount: 5000
      stadium_user.stadium.account.update(number: "30101810200000000700", company: "АО “Райффайзенбанк”, 129090, Россия, г. Москва, ул. Троицкая, д.17/1", inn: "7744000302", kpp: "775001001", bik: "044525700", agreement_number: "1234567890", date: Time.now)

      visit dashboard_withdrawal_requests_path
      fill_in "withdrawal_request_amount", with: 3000
      click_button "Перейти к выводу"
      expect(page).not_to have_content "Не все реквизиты заполнены!"
      expect(page).to have_selector('table tbody tr', :count => 1)
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
