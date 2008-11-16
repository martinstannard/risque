Sham.name { Faker::Name.first_name }

Game.blueprint do
  name 'game'
end

Player.blueprint do
  name { Sham.name }
end
