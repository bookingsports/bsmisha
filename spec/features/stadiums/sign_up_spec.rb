require 'rails_helper'

# Feature: Stadium ign up
#   As a stadium owner visitor
#   I want to sign up
#   So I can visit protected areas of the site
RSpec.feature "Sign Up", :devise do
  # Scenario: Visitor can sign up with valid email address and password
  #   Given I am not signed in
  #   When I sign up with a valid email address and password and choose Тип Стадион
  #   Then I see a successful sign up message
  scenario "stadium owner visitor can sign up with valid email address and password" do
    sign_up_with("test@example.com", "please123", "please123", "Стадион")
    txts = [
      I18n.t( "devise.registrations.signed_up"),
      I18n.t( "devise.registrations.signed_up_but_unconfirmed")
    ]

    expect(page).to have_content(/.*#{txts[0]}.*|.*#{txts[1]}.*/)
  end

  scenario "Стадион недоступен для пользователей сразу после регистрации стадиона" do
    sign_up_with("test@example.com", "please123", "please123", "Стадион")
    click_link "Стадионы"

    expect(find(:css, ".stadiums").all("*")).to be_empty
  end

  scenario "Стадион доступен для пользователей после регистрации стадиона и подтверждения админом" do
    stadium_user = create(:stadium_user, password: 'password')
    stadium_user.stadium.update status: :active

    login_as create(:user)
    visit root_path
    within('#navbar') { click_link "Стадионы" }
    expect(find(:css, '.stadiums').all('*')).to_not be_empty
    click_link "Без названия"

    expect(page).to have_text("Без названия")
  end
end
