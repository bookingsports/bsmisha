module TennisHelpers
  module SetupHelpers
    def full_setup
      @user = User.create!({
        name: 'Test User',
        email: "user@example.com",
        password: "blankertag"
      })

      @user_two = User.create!({
        name: 'Test User',
        email: "user2@example.com",
        password: "blankertag"
      })

      @user.wallet.deposit!(1000)

      @admin = Admin.create!({
        name: 'Test User',
        email: "admin@example.com",
        password: "blinkenblag"
      })

      @stadium_user = StadiumUser.create!({
        name: 'Test User',
        email: "stadium@example.com",
        password: "blinkenbleg"
      })

      @coach_user = CoachUser.create!({
        name: 'Test User',
        email: "coach@example.com",
        password: "blinkenblug"
      })

      @stadium = @stadium_user.stadium
      @stadium.update(name: "Name", status: :active)

      @area = Area.create!({
        stadium: @stadium,
        name: "area",
        price: 100,
        user: @stadium_user
      })

      @area_two = Area.create!({
        stadium: @stadium,
        name: "area_two",
        price: 150
      })

      @coach = Coach.create!({
        price: 100,
        user: @coach_user
      })

      @service = StadiumService.create!({
        service: Service.new(name: "WC"),
        price: 10,
        stadium: @stadium
      })

      @periodic_service = StadiumService.create!({
        service: Service.new(name: "Синема"),
        price: 10,
        stadium: @stadium,
        periodic: "1"
      })

      @event = Event.create!({
        product: @area,
        stadium_services: [@service, @periodic_service],
        start: Time.zone.parse("12:00:00"),
        end: Time.zone.parse("14:30:00"),
        user: @user
      })

      @event_two = Event.create!({
        product: @area,
        stadium_services: [@service, @periodic_service],
        start: Time.zone.parse("12:00:00"),
        end: Time.zone.parse("14:30:00"),
        user: @user
      })

      @event_three = Event.create!({
        product: @area_two,
        stadium_services: [@service, @periodic_service],
        start: Time.zone.parse("12:00:00"),
        end: Time.zone.parse("14:30:00"),
        user: @user
      })

      @category = Category.create!({
        name: "Футбол"
      })

      @order = Order.create!({
        events: [@event],
        user: @user
      })
    end

    def login_via_post_as(user)
      post_via_redirect user_session_path, {
        "user[email]" => user.email,
        "user[password]" => user.password
      }
    end

    def logout_via_delete
      delete destroy_user_session_path
    end
  end
end
