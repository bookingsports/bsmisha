require 'rails_helper'

RSpec.feature 'Home page' do
  before(:each) do
    visit root_path
  end

  scenario 'visit the home page' do
    expect(page.status_code).to be(200)
  end

  scenario 'home page title check', :js do
    visit root_path
    expect(page.title).to eq('Booking Sports - Бронируйте спорт надежно')
  end
end
