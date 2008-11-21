class Colour < ActiveRecord::Base

  has_many :game_players

  named_scope :random, :order => 'RAND()'

end
