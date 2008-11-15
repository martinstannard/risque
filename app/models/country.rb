class Country < ActiveRecord::Base
  
  belongs_to :region
  has_many :neighbours, :dependent => :destroy
  has_one :game_player_country
  has_one :game_player, :through => :game_player_country

  def label
    "country_#{id}"
  end

end
