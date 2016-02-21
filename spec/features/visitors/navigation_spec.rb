require 'rails_helper'

RSpec.feature 'Navigation links' do
  before :each do
    visit root_path

    within 'ul.nav' do
      expect(page).to have_link('Тренеры', href: coaches_path)
      expect(page).to have_link('Стадионы', href: stadiums_path)
      expect(page).to have_link('Учетная запись', href: '#')
    end
  end

  scenario 'for clients' do
    within 'ul.nav .dropdown-menu' do
      expect(page).to have_css('a', count: 1)
      expect(page).to have_link('Вход / Регистрация', href: new_user_session_path)
    end
  end
end
