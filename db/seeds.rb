# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_user(model, email, password)
  user = model.find_or_create_by!(email: email) do |user|
    user.password = password
    user.password_confirmation = password
  end

  puts "CREATED #{model.to_s} USER: " << user.email
  user
end

# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
SECRETS = Rails.application.secrets

create_user(Admin, SECRETS.admin_email, SECRETS.admin_password)
stadium_user = create_user(StadiumUser, SECRETS.stadium_email, SECRETS.stadium_password)
create_user(CoachUser, SECRETS.coach_email, SECRETS.coach_password)
create_user(Customer, SECRETS.customer_email, SECRETS.customer_password)

c = Category.create!(name: "Футбол", parent: Category.create(name: "Стадион"))
stadium_user.stadium = Stadium.create!(name: 'Арена "Открытие"', category: c, phone: '123')
stadium_user.stadium.courts.create! name: 'Первый'
stadium_user.stadium.courts.create! name: 'Второй'
