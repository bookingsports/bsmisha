# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def create_user(model, email, password)
  user = model.create! email: email, name: "Test User", password: password, password_confirmation: password

  puts "CREATED #{model.to_s} USER: " << user.email
  user
end

categories = ['Теннис', 'Групповые занятия', 'Йога', 'Фитнесс']
categories.each { |name| Category.create! name: name }

create_user(Admin, 'admin@bookingsports.ru', 'changeme')

coach_user = create_user(CoachUser,  'coach@bookingsports.ru', 'changeme')
customer = create_user(Customer, 'customer@bookingsports.ru', 'changeme')

stadium_names = ["Opentennis 2015", "Group Stadium", "Yoga Stadium", "Fitness Stadium"]
stadium_addresses = ["ул. Большая Филевская, 20, Москва, Россия, 121309", "Перовская ул., 20, Москва, Россия, 111398", "ул. Пришвина, 3, Москва, Россия, 127549", "Котляковская ул., 1с17, Москва, Россия, 115201"]

(0..3).each do |number|
  stadium_user = create_user(StadiumUser, "stadium#{number}@bookingsports.ru", 'changeme')
  stadium_user.stadium.update(name: stadium_names[number], category: Category.where(name: categories[number]).first, phone: '+7985444484', address: stadium_addresses[number], status: :active, opens_at: "07:00", closes_at: "23:00")
  stadium_user.stadium.areas.create! name: 'Первая', price: 500
  stadium_user.stadium.areas.create! name: 'Вторая', price: 1000
  stadium_user.wallet.deposits.create amount: 100000, status: :active

  service = Service.create name: "Инструктор"
  stadium_service = stadium_user.stadium.stadium_services.create price: 500, service: service

  stadium_user.stadium.account.update(number: "30101810200000000700", company: "АО “Райффайзенбанк”, 129090, Россия, г. Москва, ул. Троицкая, д.17/1", inn: "7744000302", kpp: "775001001", bik: "044525700", agreement_number: "1234567890", date: Time.now)
end

coach_user.coach.account.update(number: "30101810200000000700", company: "АО “Райффайзенбанк”, 129090, Россия, г. Москва, ул. Троицкая, д.17/1", inn: "7744000302", kpp: "775001001", bik: "044525700", agreement_number: "1234567890", date: Time.now)

customer.wallet.deposits.create amount: 100000, status: :active
coach_user.wallet.deposits.create amount: 100000, status: :active
