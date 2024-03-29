require 'rails_helper'

# Feature: Sign up
#   As a visitor
#   I want to sign up
#   So I can visit protected areas of the site
RSpec.feature "Sign Up", :devise do
  # Scenario: Visitor can sign up with valid email address and password
  #   Given I am not signed in
  #   When I sign up with a valid email address and password
  #   Then I see a successful sign up message
  scenario "visitor can sign up with valid email address and password" do
    sign_up_with("Test User", "test@example.com", "please123", "please123")
    txts = [
      I18n.t( "devise.registrations.signed_up"),
      I18n.t( "devise.registrations.signed_up_but_unconfirmed")
    ]

    expect(page).to have_content(/.*#{txts[0]}.*|.*#{txts[1]}.*/)
  end

  # Scenario: Visitor cannot sign up with invalid email address
  #   Given I am not signed in
  #   When I sign up with an invalid email address
  #   Then I see an invalid email message
  scenario "visitor cannot sign up with invalid email address" do
    sign_up_with("Test User", "bogus", "please123", "please123")

    expect(page).to have_content("Эл. почта имеет неверное значение")
  end

  # Scenario: Visitor cannot sign up without password
  #   Given I am not signed in
  #   When I sign up without a password
  #   Then I see a missing password message
  scenario "visitor cannot sign up without password" do
    sign_up_with("Test User", "test@example.com", "", "")

    expect(page).to have_content("Пароль не может быть пустым")
  end

  # Scenario: Visitor cannot sign up with a short password
  #   Given I am not signed in
  #   When I sign up with a short password
  #   Then I see a "too short password" message
  scenario "visitor cannot sign up with a short password" do
    sign_up_with("Test User", "test@example.com", "please", "please")

    expect(page).to have_content("Пароль недостаточной длины")
  end

  # Scenario: Visitor cannot sign up without password confirmation
  #   Given I am not signed in
  #   When I sign up without a password confirmation
  #   Then I see a missing password confirmation message
  scenario "visitor cannot sign up without password confirmation" do
    sign_up_with("Test User", "test@example.com", "please123", "")

    expect(page).to have_content("Подтверждение пароля не совпадает")
  end

  # Scenario: Visitor cannot sign up with mismatched password and confirmation
  #   Given I am not signed in
  #   When I sign up with a mismatched password confirmation
  #   Then I should see a mismatched password message
  scenario "visitor cannot sign up with mismatched password and confirmation" do
    sign_up_with("Test User", "test@example.com", "please123", "mismatch")

    expect(page).to have_content("Подтверждение пароля не совпадает")
  end
end
