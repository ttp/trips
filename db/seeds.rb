# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
puts 'DEFAULT USERS'
user = User.create_with(
  name: 'admin',
  role: 'admin',
  password: 'password',
  password_confirmation: 'password'
).find_or_create_by(email: 'admin@pohody.com.ua')
puts 'user: ' << user.name


puts 'Regions'
Region.delete_all
regions = [
    {id: 1, name: "Карпати"},
    {id: 2, name: "Крим"},
    {id: 3, name: "Кавказ"},
    {id: 4, name: "Туреччина"},
    {id: 5, name: "Румунія"},
    {id: 6, name: "Непал"}
]
regions.each do |region|
  row = Region.new(region)
  row.id = region[:id]
  row.save
end
