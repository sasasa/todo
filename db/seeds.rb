# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "faker"

# Create users with random IP addresses, for use in demonstrating tests
# involving external HTTP services.
User.all.each do |user|
  pp ramdom_ip  = Faker::Internet.ip_v4_address
  user.last_sign_in_ip = ramdom_ip
  # user.tasks.create!(content: "content1", finished: false, due_on: 1.week.after)
  # user.tasks.create!(content: "content2", finished: false, due_on: 1.week.after)
  # user.tasks.create!(content: "content3", finished: false, due_on: 1.week.after)
  # user.tasks.create!(content: "content4", finished: false, due_on: 1.week.after)
  # user.tasks.create!(content: "content5", finished: false, due_on: 1.week.after)
  user.save
end
# rails db:seed

# 10.times do
#   User.create!(
#     first_name: Faker::Name.first_name,
#     last_name: Faker::Name.last_name,
#     email: Faker::Internet.email,
#     password: Faker::Internet.password,
#     last_sign_in_ip: Faker::Internet.ip_v4_address,
#   )
# end