require 'rails_helper'

# Feature: Coach sign up
#   As a coach  visitor
#   I want to sign up
#   So I can visit protected areas of the site
RSpec.feature "Sign Up", :devise, :js do
  # Scenario: Visitor can sign up with valid email address and password
  #   Given I am not signed in
  #   When I sign up with a valid email address and password and choose Тип Тренер
  #   Then I see a successful sign up message

  let(:coach_user) {build(:coach_user)}

  scenario "coach visitor can sign up with valid email address and password" do
    sign_up_with(coach_user.name, coach_user.email, coach_user.password, coach_user.password, "Тренер")
    txts = [
      I18n.t( "devise.registrations.signed_up"),
      I18n.t( "devise.registrations.signed_up_but_unconfirmed")
    ]

    expect(page).to have_content(/.*#{txts[0]}.*|.*#{txts[1]}.*/)
  end

  scenario "Тренер недоступен для пользователей сразу после регистрации тренера" do
    sign_up_with(coach_user.name, coach_user.email, coach_user.password, coach_user.password, "Тренер")
    click_link "Тренеры"

    expect(find(:css, ".coaches").all("*")).to be_empty
  end

  scenario "Тренер доступен для пользователей после регистрации тренера и привязки к стадиону" do
    user = create(:stadium_user, password: 'password')
    user.stadium.update(name: "Стадион")
    sign_up_with(coach_user.name, coach_user.email, coach_user.password, coach_user.password, "Тренер")
    visit dashboard_grid_path
    within(".dashboard-nav") { click_link "Стадионы" }
    click_button "Привязаться"
    within("#navbar") { click_link "Тренеры" }
    expect(find(:css, ".coaches").all("*")).to_not be_empty
    click_link coach_user.name

    expect(page).to have_text(coach_user.name)
  end
end
