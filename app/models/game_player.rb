# == Schema Information
# Schema version: 20081119013232
#
# Table name: game_players
#
#  id                           :integer(4)      not null, primary key
#  game_id                      :integer(4)
#  player_id                    :integer(4)
#  armies_to_allocate           :integer(4)      default(0)
#  created_at                   :datetime
#  updated_at                   :datetime
#  completed_initial_allocation :integer(4)      default(0)
#  colour                       :string(255)
#

class GamePlayer < ActiveRecord::Base

  belongs_to :game
  belongs_to :player
  belongs_to :colour
  has_many :countries

  def add_armies(armies)
    update_attribute(:armies_to_allocate, armies_to_allocate + armies)
  end

  def armed_countries
    countries.find(:all, :conditions => "armies > 1")
  end

end
