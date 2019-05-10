# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "loading providers..."
load('db/seeds/providers.rb')
puts "loading categories..."
load('db/seeds/categories.rb')
puts "loading experiences..."
load('db/seeds/experiences.rb')
puts "loading degrees..."
load('db/seeds/degrees.rb')
puts "loading brands..."
load('db/seeds/brands.rb')
puts "loading services..."
load('db/seeds/services.rb')
puts "loading lines..."
load('db/seeds/lines.rb')
puts "loading harmonies..."
load('db/seeds/harmonies.rb')
puts "loading colors..."
load('db/seeds/colors.rb')
puts "loading tags..."
load('db/seeds/tags.rb')
puts 'loading product attributes..'
load 'db/seeds/product_attributes.rb'

GlobalVar.create!(name: 'referral_coupon_percentage', value: 10)
GlobalVar.create!(name: 'commission_percentage', value: 10)

