class Game < ActiveRecord::Base
  
  has_many :game_players, :dependent => :destroy
  has_many :players, :through => :game_players
  belongs_to :world, :dependent => :destroy
  belongs_to :current_player, :class_name => "GamePlayer", :foreign_key => "current_player", :dependent => :destroy
  serialize :player_list

  after_create :setup

  def setup
    self.world = World.begat
    self.players << Player.find(:all,:limit => 4).sort_by{ rand }
    self.allocate_countries
    self.allocate_initial_armies
    self.current_player = self.game_players.first
    self.player_list = game_players.map{|p| p.id}
    self.save
  end
  
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
        next if country.nil?
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

  def get_next_player
    self.current_player = GamePlayer.find(self.player_list.shift)
    self.player_list << self.current_player.id
    self.save
    self.player_list.first
  end

  def get_game_player
    if self.current_player && self.current_player.armies_to_allocate == 0
      self.current_player = self.game_players.find(:first,:conditions => "armies_to_allocate > 0")
      self.save
    end
    if self.current_player.nil?
      self.is_allocation_round = 0
      self.save
      self.game_players.find(:first,:order => "id ASC")
    else
      self.current_player
    end
  end
    
  def award_armies(game_player)
    world.award_armies(game_player)
  end

  def graph
    world.graph
  end

end
