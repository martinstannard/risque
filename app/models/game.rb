class Game < ActiveRecord::Base
  
  has_many :game_players
  has_many :players, :through => :game_players
  belongs_to :world
  
end
