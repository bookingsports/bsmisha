require "rails_helper"

RSpec.describe "EventsApi" do
  before(:each) do
    full_setup
    login_via_post_as(@user)
  end

  describe "grid at dashboard" do
    before(:each) do
      @event_four = Event.create!({
        product: @area,
        stadium_services: [@service, @periodic_service],
        start: Time.zone.parse("12:00:00"),
        end: Time.zone.parse("14:30:00"),
        user: @user_two
      })

      @order1 = Order.create!({
        events: [@event, @event_two],
        user: @user
      })

      @order2 = Order.create!({
        events: [@event_four],
        user: @user_two
      })

      @order1.paid!
      @order2.paid!
    end

=begin
    context "customer user" do
      it "shows all my events without others" do
        get area_my_events_path(@area, format: :json)
        data = JSON.parse(response.body)
        grouped = data.group_by {|d| d["user_name"]}

        expect(data.count).to eq(@user.events.of_products(@area).count)
        expect(grouped.keys.count).to eq(1)
        expect(grouped.keys.first).to eq(@user.name)
      end
    end
=end

    context "stadium user" do
      before(:each) do
        logout_via_delete
        login_via_post_as(@stadium_user)
      end

      it "shows all paid events from all users" do
        get area_my_events_path(@area, format: :json)
        data = JSON.parse(response.body)

        expect(data.count).to eq(3)
      end

      it "creates new event" do
        expect(Event.count).to eq(4)
        post area_my_events_path(@area), {
          event: {
            "id" => "",
            "start" => "Mon Jul 20 2015 12:00:00 GMT+0300 (MSK)",
            "end" => "Mon Jul 20 2015 12:30:00 GMT+0300 (MSK)",
            "description" => "",
            "recurrence_id" => "",
            "recurrence_rule" => "",
            "recurrence_exception" => "",
            "start_timezone" => "",
            "end_timezone" => "",
            "is_all_day" => "false"
          }
        }

        expect(Event.count).to eq(5)
        expect(Event.last.user.id).to eq(@stadium_user.id)
      end
    end
  end

  describe "grid at area show view" do
    describe "shows events" do
      context "user one" do
        it "Gets all events from current area" do
          get stadium_area_events_path(@area.stadium, @area, format: :json)
          data = JSON.parse(response.body)

          expect(data.count).to eq(2)
        end

        it "shows all events from all areas when accessing specific path" do
          get events_stadium_areas_path(@area.stadium, format: :json)
          data = JSON.parse(response.body)

          expect(data.count).to eq(3)
        end
      end

      context "user two" do
        before :each do
          logout_via_delete
          login_via_post_as(@user_two)
        end

        it "cant see upaid events of other user" do
          get stadium_area_events_path(@area.stadium, @area, format: :json)
          data = JSON.parse(response.body)

          expect(data.count).to eq(0)
        end

        it "can see paid events of other user" do
          @order.pay!
          get stadium_area_events_path(@area.stadium, @area, format: :json)
          data = JSON.parse(response.body)

          expect(data.count).to eq(1)
        end
      end
    end

    it "Creates new event" do
      post stadium_area_events_path(@area.stadium, @area), {
        event: {
          "id" => "",
          "start" => "Mon Jul 20 2015 12:00:00 GMT+0300 (MSK)",
          "end" => "Mon Jul 20 2015 12:30:00 GMT+0300 (MSK)",
          "description" => "",
          "recurrence_id" => "",
          "recurrence_rule" => "",
          "recurrence_exception" => "",
          "start_timezone" => "",
          "end_timezone" => "",
          "is_all_day" => "false"
        }
      }

      expect(Event.count).to eq(4)
      expect(Event.last.user.id).to be(@user.id)
    end

    it "creates event with additional services" do
      post stadium_area_events_path(@coach, @area), {
        event: {
          "id" => "",
          "start" => "Mon Jul 20 2015 12:00:00 GMT+0300 (MSK)",
          "end" => "Mon Jul 20 2015 12:30:00 GMT+0300 (MSK)",
          "description" => "",
          "recurrence_id" => "",
          "recurrence_rule" => "",
          "recurrence_exception" => "",
          "start_timezone" => "",
          "end_timezone" => "",
          "is_all_day" => "false",
          "stadium_service_ids" => [@service.id.to_s, @periodic_service.id.to_s]
        }
      }

      expect(Event.last.stadium_services.count).to eq(2)
    end

    it "creates coach event" do
      post coach_area_events_path(@area.stadium, @area), {
        event: {
          "id" => "",
          "start" => "Mon Jul 20 2015 12:00:00 GMT+0300 (MSK)",
          "end" => "Mon Jul 20 2015 12:30:00 GMT+0300 (MSK)",
          "description" => "",
          "recurrence_id" => "",
          "recurrence_rule" => "",
          "recurrence_exception" => "",
          "start_timezone" => "",
          "end_timezone" => "",
          "is_all_day" => "false",
          "stadium_service_ids" => [@service.id.to_s, @periodic_service.id.to_s]
        }
      }

      expect(@coach.events.count).to eq(1)
    end

    it "can move unpaid event freely" do
      put stadium_area_event_path(@area.stadium, @area, @event.id), {
        "event" => {
          "id" => @event.id,
          "start" => "Mon Jul 20 2015 13:11:00 GMT+0300 (MSK)",
          "end" => "Mon Jul 20 2015 12:22:00 GMT+0300 (MSK)",
          "visual_type" => "owned",
          "user_name" => "TestCustomer@tennis.ru",
          "description" => "TestCustomer@tennis.ru",
          "recurrence_id" => "",
          "recurrence_rule" => "",
          "recurrence_exception" => ""
        }
      }

      @event.reload

      expect(@event.start.min).to eq(11)
      expect(@event.end.min).to eq(22)
    end

    it "creates a event change when moves paid event" do
      @event.order.paid!

      put stadium_area_event_path(@area.stadium, @area, @event.id), {
        "event" => {
          "id" => @event.id,
          "start" => "Mon Jul 20 2015 13:11:00 GMT+0300 (MSK)",
          "end" => "Mon Jul 20 2015 12:22:00 GMT+0300 (MSK)",
          "visual_type" => "owned",
          "user_name" => "TestCustomer@tennis.ru",
          "description" => "TestCustomer@tennis.ru",
          "recurrence_id" => "",
          "recurrence_rule" => "",
          "recurrence_exception" => ""
        }
      }

      @user.reload
      @event.reload

      expect(@event.event_changes.unpaid.count).to eq(1)
      expect(@user.event_changes.unpaid.count).to eq(1)
      expect(@event.start.min).to eq(11)
      expect(@event.end.min).to eq(22)
      expect(@event.start_before_change.min).to eq(00)
      expect(@event.end_before_change.min).to eq(30)
    end

    context "paid event changed" do
      before :each do
        @event.order.paid!
        put stadium_area_event_path(@area.stadium, @area, @event.id), {
          "event" => {
            "id" => @event.id,
            "start" => "Mon Jul 20 2015 13:11:00 GMT+0300 (MSK)",
            "end" => "Mon Jul 20 2015 12:22:00 GMT+0300 (MSK)",
            "visual_type" => "owned",
            "user_name" => "TestCustomer@tennis.ru",
            "description" => "TestCustomer@tennis.ru",
            "recurrence_id" => "",
            "recurrence_rule" => "",
            "recurrence_exception" => ""
          }
        }

        @user.reload
        @event.reload
      end

      context "change is unpaid" do
        scenario "stadium owner should not see changed datetimes" do
          logout_via_delete
          login_via_post_as(@stadium_user)
          get area_my_events_path(@area, format: :json)

          data = JSON.parse(response.body)
          event = data.detect {|e| e["id"] == @event.id }

          expect(event["start"]).to eq(Time.zone.parse("12:00:00").as_json)
          expect(event["visual_type"]).to eq("paid")
        end
      end
    end
  end
end
