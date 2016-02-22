require 'rails_helper'

RSpec.shared_examples 'signed_in' do |param|
  scenario 'it should show profile, orders and sign_out links' do
    within '.navbar .balance' do
      expect(page).to have_link('Баланс: 0 руб.', href: deposit_requests_path)
    end

    within @nav do
      within @subnav do
        expect(page).to have_css('a', count: 3)
        expect(page).to have_link('Личный кабинет', href: dashboard_grid_path)
        expect(page).to have_link('Заказы', href: my_events_path)
        expect(page).to have_link('Выход', href: destroy_user_session_path)
      end
    end
  end
end

RSpec.feature 'Navigation links' do
  before :each do
    visit root_path

    @navbar = '.navbar'
    @nav = 'ul.nav'
    @subnav = '.dropdown-menu'

    within @nav do
      expect(page).to have_link('Тренеры', href: coaches_path)
      expect(page).to have_link('Стадионы', href: stadiums_path)
      expect(page).to have_link('Учетная запись', href: '#')
    end
  end

  scenario 'for visitors it should show only one sign_in/sign_up link' do
    within @navbar do
      expect(page).to_not have_css('.balance')
    end

    within @nav do
      within @subnav do
        expect(page).to have_css('a', count: 1)
        expect(page).to have_link('Вход / Регистрация', href: new_user_session_path)
      end
    end
  end

  context 'signed in users' do
    before :each do
      login_as user
      visit root_path
    end

    context 'for customers' do
      let(:user) { create(:customer) }
      it_behaves_like 'signed_in'
    end

    context 'for coaches' do
      let(:user) { create(:coach_user) }
      it_behaves_like 'signed_in'
    end

    context 'for stadium users' do
      let(:user) { create(:stadium_user) }
      it_behaves_like 'signed_in'
    end

    context 'for admins' do
      let(:user) { create(:admin) }

      scenario 'it should display only admin and logout paths, without balance' do
        within @navbar do
          expect(page).to_not have_css('.balance')
        end

        within @nav do
          within @subnav do
            expect(page).to have_css('a', count: 2)
            expect(page).to have_link('Админка', href: rails_admin_path)
            expect(page).to have_link('Выход', href: destroy_user_session_path)
          end
        end
      end
    end
  end
end
