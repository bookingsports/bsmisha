# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_user(model, email, password)
  user = model.find_or_create_by!(name: 'Test User', email: email) do |user|
    user.password = password
    user.password_confirmation = password
  end

  puts "CREATED #{model.to_s} USER: " << user.email
  user
end

create_user(Admin, 'admin@bookingsports.ru', 'changeme')
stadium_user = create_user(StadiumUser, 'stadium@bookingsports.ru', 'changeme')
create_user(CoachUser, 'coach@bookingsports.ru', 'changeme')
create_user(Customer, 'customer@bookingsports.ru', 'changeme')

c = Category.create!(name: "Футбол", parent: Category.create(name: "Стадион"))
stadium_user.stadium = Stadium.create!(name: 'Арена "Открытие"', category: c, phone: '123')
stadium_user.stadium.courts.create! name: 'Первый'
stadium_user.stadium.courts.create! name: 'Второй'
