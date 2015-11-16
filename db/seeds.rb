# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless User.exists?(email: "admin@bandcamp.com")
  User.create!(email: "admin@bandcamp.com", password: "password", role: :admin)
end

unless User.exists?(email: "user@bandcamp.com")
  User.create!(email: "user@bandcamp.com", password: "password")
end

["Google Chrome", "Trello"].each do |name|
  unless Project.exists?(name: name)
    Project.create!(name: name, description: "A sample project about #{name}")
  end
end

unless  State.exists?
  State.create(name: "New", color: "#0066CC")
  State.create(name: "Open", color: "#008000")
  State.create(name: "Closed", color: "#990000")
  State.create(name: "Awesome", color: "#663399")
end
