class GamePlayer < ActiveRecord::Base

  belongs_to :game
  belongs_to :player
  has_many :game_player_countries, :dependent => :destroy
  has_many :countries, :through => :game_player_countries

  def add_armies(armies)
    update_attribute(:armies_to_allocate, armies_to_allocate + armies)
  end

  def armed_countries
    self.game_player_countries.find(:all, :conditions => "armies > 1").map{|c| c.country}
  end

end
