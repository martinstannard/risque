class GameController < ApplicationController
  def new
    
  end

  def show
  end
  
  def create
    g = Game.new
    g.world = World.begat
    g.save
    g.players << Player.find(:all,:limit => 4)
  end
end
