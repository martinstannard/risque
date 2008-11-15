class GamePlayer < ActiveRecord::Base

  belongs_to :game
  belongs_to :player
  has_many :game_player_countries, :dependent => :destroy
  has_many :countries, :through => :game_player_countries

  def add_armies(armies)
    update_attribute(:armies_to_allocate, armies_to_allocate + armies)
  end

end
