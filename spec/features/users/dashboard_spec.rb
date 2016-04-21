require 'rails_helper'

RSpec.feature "customer dashboard" do

  let!(:user) {create(:customer)}

  before(:each) do
    signin(user.email, user.password)
  end

  describe "events", :js do
    context "unpaid and not confirmed" do
      let!(:event) {create(:event, user: user, confirmed: false)}

      it "should display this event" do
        visit my_events_path
        expect(page).to have_selector('table#unconfirmed-events tbody tr', :count => 1)
      end

      it "should allow booking event" do
        visit my_events_path
        all('#event_ids_').each {|ch| check(ch[:id]) }
        page.accept_confirm do
          click_button "Забронировать"
        end

        expect(page).to_not have_selector('table#unconfirmed-events tbody tr')
        expect(page).to have_selector('table#confirmed-events tbody tr', :count => 1)
      end

      it "should not allow booking empty events" do
        visit my_events_path
        page.accept_confirm do
          click_button "Забронировать"
        end

        expect(page).to have_content('Не выбрано ни одного заказа!')
      end

      it "should allow deleting event" do
        visit my_events_path
        all('#event_ids_').each {|ch| check(ch[:id]) }
        page.accept_confirm do
          click_button "Удалить"
        end

        expect(page).to_not have_selector('table#unconfirmed-events tbody tr')
      end

      it "should not allow deleting empty events" do
        visit my_events_path
        page.accept_confirm do
          click_button "Удалить"
        end

        expect(page).to have_content('Не выбрано ни одного заказа!')
      end
    end

    context "unpaid and confirmed" do
      let!(:event) {create(:event, user: user, confirmed: true)}

      it "should display this event" do
        visit my_events_path
        expect(page).to have_selector('table#confirmed-events tbody tr', :count => 1)
      end

      it "should allow deleting event" do
        visit my_events_path
        all('#event_ids_').each {|ch| check(ch[:id]) }
        page.accept_confirm do
          click_button "Удалить"
        end

        expect(page).to_not have_selector('table#confirmed-events tbody tr')
      end

      it "should not allow deleting empty events" do
        visit my_events_path
        page.accept_confirm do
          click_button "Удалить"
        end

        expect(page).to have_content('Не выбрано ни одного заказа!')
      end
    end

    context "recoupments" do
      let!(:recoupment) {create(:recoupment, user: user)}

      it "should display this recoupment" do
        visit my_events_path
        expect(page).to have_selector('table#recoupments tbody tr', :count => 1)
      end
    end

    context "paid without transfer" do
      let!(:order) {create(:order, status: :paid)}
      let!(:event) {create(:event, user: user, order: order)}

      it "should display this event" do
        visit my_events_path
        expect(page).to have_selector('table#paid-events tbody tr', :count => 1)
      end
    end

    context "paid with unpaid transfer" do
      let!(:order) {create(:order, status: :paid)}
      let!(:event) {create(:event, user: user, order: order)}
      let!(:update) {event.update start: event.start + 1.day, stop: event.stop + 1.day}

      it "should display this event" do
        visit my_events_path
        expect(page).to have_selector('table#paid-events tbody tr', :count => 1)

      end

      it "should display event change" do
        visit my_events_path
        expect(page).to have_selector('table#event-changes tbody tr', :count => 1)
      end

      it "should allow to confirm transfer" do
        visit my_events_path
        expect(page).to have_content('Подтвердить перенос')
        page.accept_confirm do
          click_on "Подтвердить перенос"
        end
        expect(page).to_not have_selector('table#event-changes tbody tr')
        expect(page).to have_content('Оплачен')
      end
    end

    context "paid with paid transfer" do
      let!(:order) {create(:order, status: :paid)}
      let!(:event) {create(:event, user: user, order: order)}
      let!(:update) {event.update start: event.start + 1.day, stop: event.stop + 1.day}
      let!(:event_change) {event.event_change.update order: order}

      it "should display this event" do
        visit my_events_path
        expect(page).to have_selector('table#paid-events tbody tr', :count => 1)
      end

      it "should not display event change" do
        visit my_events_path
        expect(page).to_not have_selector('table#event-changes tbody tr')
      end

      it "should note that the transfer is paid" do
        visit my_events_path
        expect(page).to have_content('Оплачен')
      end
    end
  end
end
