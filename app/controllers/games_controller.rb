class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def show
  end
  
  def create
    g = Game.new
    g.world = World.begat
    g.save!
    g.players << Player.find(:all,:limit => 4).sort_by{ rand }
    g.allocate_countries
    g.allocate_initial_armies
    g.current_player = g.game_players.first
    g.save!
    redirect_to game_path(g)
    return false 
  end
  
  def game
    @game = Game.find(params[:id])
    @game_player = @game.get_game_player    
    render :partial => "allocate"
  end

  def allocate_armies
    @game_player_country = GamePlayerCountry.find(:first, :conditions =>["game_player_id = ? and country_id = ?",params[:game_player_id],params[:country_id]])
    @game_player_country.armies += params[:armies].to_i
    @game_player_country.save
    @game_player = @game_player_country.game_player
    @game_player.armies_to_allocate -= params[:armies].to_i
    @game_player.save
    @game = @game_player.game
    @game_player = @game_player.game.get_game_player
    if @game_player.nil? && @game.is_allocation_round?
      @game_player = @game.game_player.find(:first,:conditions => "id ASC")
      @game.is_allocation_round = false
      @game.save
    end
    render :partial => "allocate", :layout => false
  end

end
