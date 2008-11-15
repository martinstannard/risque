class GamePlayerCountry < ActiveRecord::Base

  belongs_to :country
  belongs_to :game_player

  def add_armies(count = 1)
    update_attribute(:armies, armies + count)
  end

end
