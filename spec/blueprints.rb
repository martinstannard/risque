require 'faker'

Sham.name { Faker::Name.first_name }

Game.blueprint do
  name 'game'
end

Player.blueprint do
  name { Sham.name }
end

World.blueprint do
  name { Sham.name }
end

Region.blueprint do
  name { Sham.name }
end

Country.blueprint do
  name { Sham.name }
  armies { 0 }
  game_player { GamePlayer.make }
end

GamePlayer.blueprint do
  player { Player.make }
  colour { 'red' }
end

GamePlayerCountry.blueprint do
  armies 3
  game_player { GamePlayer.make }
  country { Country.make }
end
