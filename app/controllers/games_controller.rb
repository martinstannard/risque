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
    @game_player = @game.current_player
    render :partial => "allocate"
  end
end
