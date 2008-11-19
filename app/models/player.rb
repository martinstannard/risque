# == Schema Information
# Schema version: 20081119013232
#
# Table name: players
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Player < ActiveRecord::Base

  has_many :game_players
  has_many :games, :through => :game_players
  
end
