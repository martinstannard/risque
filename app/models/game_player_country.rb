# == Schema Information
# Schema version: 20081119013232
#
# Table name: game_player_countries
#
#  id             :integer(4)      not null, primary key
#  game_player_id :integer(4)
#  country_id     :integer(4)
#  armies         :integer(4)      default(0)
#  created_at     :datetime
#  updated_at     :datetime
#

class GamePlayerCountry < ActiveRecord::Base

  belongs_to :country
  belongs_to :game_player

  def add_armies(count = 1)
    update_attribute(:armies, armies + count)
  end

end
