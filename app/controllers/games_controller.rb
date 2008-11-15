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
    g.current_player = g.players.first.id
    redirect_to game_path(g)
    return false 
  end
  
  def game
    @game = Game.find(params[:id])
    @player = @game.current_player
  end
end
