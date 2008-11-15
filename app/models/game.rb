class Game < ActiveRecord::Base
  
  has_many :game_players
  has_many :players, :through => :game_players
  belongs_to :world
  has_one :current_player, :class => "Player", :foreign_key => "current_player"
  
  def allocate_countries
    countries = []
    world.regions.each do |r|
      r.countries.each do |c|
        countries << c
      end    
    end
    countries = countries.sort_by{ rand }
    countries.in_groups_of(game_players.size).each do |group|
      group.each_with_index do |country,index|
        GamePlayerCountry.create!(:game_player_id => game_players[index].id,:country_id => country.id, :armies => 1)
      end
    end
  end
  
  def allocate_initial_armies
    game_players.each do |gp|
      gp.armies_to_allocate = gp.game_player_countries.count
      gp.save
    end
  end
  
end
