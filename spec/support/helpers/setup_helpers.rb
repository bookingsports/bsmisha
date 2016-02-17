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

      @stadium_owner = StadiumUser.create!({
        name: 'Test User',
        email: "stadium@example.com",
        password: "blinkenbleg"
      })

      @coach_owner = CoachUser.create!({
        name: 'Test User',
        email: "coach@example.com",
        password: "blinkenblug"
      })

      @stadium = @stadium_owner.product
      @stadium.update(name: "Name")

      @court = Court.create!({
        stadium: @stadium,
        name: "court",
        price: 100,
        owner: @stadium_owner
      })

      @court_two = Court.create!({
        stadium: @stadium,
        name: "court_two",
        price: 150
      })

      @coach = Coach.create!({
        price: 100,
        owner: @coach_owner
      })

      @service = ProductService.create!({
        service: Service.new(name: "WC"),
        price: 10,
        product: @court
      })

      @periodic_service = ProductService.create!({
        service: Service.new(name: "Синема"),
        price: 10,
        product: @court,
        periodic: "1"
      })

      @event = Event.create!({
        products: [@court, @coach],
        product_services: [@service, @periodic_service],
        start: Time.zone.parse("12:00:00"),
        end: Time.zone.parse("14:30:00"),
        user: @user
      })

      @event_two = Event.create!({
        products: [@court],
        product_services: [@service, @periodic_service],
        start: Time.zone.parse("12:00:00"),
        end: Time.zone.parse("14:30:00"),
        user: @user
      })

      @event_three = Event.create!({
        products: [@court_two],
        product_services: [@service, @periodic_service],
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

      Option.create!({
        tax: 5
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
