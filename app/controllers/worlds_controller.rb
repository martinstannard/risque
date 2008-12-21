class WorldsController < ApplicationController

  def borders
    world = Game.find(params[:id]).world
    respond_to do |format|
      format.js do
        render :json => world.borders.to_json
      end
    end
  end

end
