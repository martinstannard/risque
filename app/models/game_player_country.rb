class GamePlayerCountry < ActiveRecord::Base

  belongs_to :country
  belongs_to :game_player

end
