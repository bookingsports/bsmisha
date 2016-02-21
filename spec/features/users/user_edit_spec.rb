require 'rails_helper'

# Feature: User edit
#   As a user
#   I want to edit my user profile
#   So I can change my email address
RSpec.feature "User edit" do
  # Scenario: User changes email address
  #   Given I am signed in
  #   When I change my email address
  #   Then I see an account updated message
  # scenario 'user changes email address' do
  #   user = FactoryGirl.create(:user)
  #   login_as(user, :scope => :user)
  #   visit edit_user_registration_path(user)
  #   fill_in 'Эл. почта', :with => 'newemail@example.com'
  #   fill_in '#user_current_password', :with => user.password
  #   click_button 'Update'
  #   txts = [I18n.t( 'devise.registrations.updated'), I18n.t( 'devise.registrations.update_needs_confirmation')]
  #   expect(page).to have_content(/.*#{txts[0]}.*|.*#{txts[1]}.*/)
  # end

  # Scenario: User cannot edit another user's profile
  #   Given I am signed in
  #   When I try to edit another user's profile
  #   Then I see my own 'edit profile' page
  scenario "user cannot cannot edit another user's profile", :me do
    me = FactoryGirl.create(:user)
    other = FactoryGirl.create(:user, email: "other@example.com")
    login_as(me, scope: :user)

    visit edit_user_registration_path(other)

    expect(page).to have_content "Заполните эти поля если хотите поменять пароль"
    expect(page).to have_field("Эл. почта", with: me.email)
  end
end
