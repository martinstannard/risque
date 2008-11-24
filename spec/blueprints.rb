require 'faker'

Sham.name { Faker::Name.first_name }

Colour.blueprint do
  name { 'red' }
  hex { 'f00' }
end

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
  colour { Colour.make }
end

Country.blueprint do
  name { Sham.name }
  armies { 0 }
  game_player { GamePlayer.make }
  x_position { 50 }
  y_position { 100 }
end

GamePlayer.blueprint do
  player { Player.make }
  colour { Colour.make }
end

