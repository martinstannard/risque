class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    g = Game.create
    #g.world.graph
    redirect_to game_path(g)
    return false 
  end

  def game
    @game = Game.find(params[:id])
    @game_player = @game.current_player
    if @game_player.armies_to_allocate > 0
      render :partial => "allocate"
    else
      render :partial => "attack"
    end
  end

  def get_neighbours
    @country = Country.find(params[:country_id])
    @neighbours = @country.neighbours
    @game_player = @country.game_player
    render :partial => "attack_target", :layout => false
  end

  def attack
    @game = Game.find(params[:game_id])
    @game_player = GamePlayer.find(params[:game_player_id])
    @attacking_country = Country.find(params[:attacker_country_id])
    @target_country = Country.find(params[:target_country_id])
    @armies = params[:armies].to_i

    report = @attacking_country.attack(@target_country, @armies)
    flash[:notice] = report
    logger.info report
    #@game.world.graph(:mode => :player)
    render :partial => "attack", :layout => false
  end

  def pass_turn
    @game_player = GamePlayer.find(params[:game_player_id])
    @game = @game_player.game
    @game_player = GamePlayer.find(@game.get_next_player)


    #TODO avoid the magic number of how many armies you get per turn.
    @game_player.add_armies(5)
    @game.world.award_bonuses(@game_player)
    flash[:notice] = nil
    render :partial => "allocate", :layout => false
  end

  def allocate_armies
    @game_player = GamePlayer.find(params[:game_player_id])
    @country = Country.find(params[:country_id])
    @country.add_armies(params[:armies].to_i)
    @game_player.add_armies(-params[:armies].to_i)

    @game = @game_player.game
    #@game.world.graph(:mode => :player)

    if @game_player.completed_initial_allocation? && @game_player.armies_to_allocate <= 0
      logger.info("going to attack...")
      render :partial => "attack", :layout => false
    elsif @game_player.completed_initial_allocation? && @game_player.armies_to_allocate > 0
      logger.info("still allocating...")
      render :partial => "allocate", :layout => false
    elsif @game_player.armies_to_allocate > 0
      logger.info("still allocating...")
      render :partial => "allocate", :layout => false
    elsif @game_player.armies_to_allocate <= 0
      logger.info("Done allocating, passing to the next player to allocate.")
      @game_player.completed_initial_allocation = 1
      @game_player.save!
      @game_player = GamePlayer.find(@game.get_next_player)
      if @game_player.completed_initial_allocation?
        pass_turn
      else
        render :partial => "allocate", :layout => false
      end

    end
  end

  def map
    game = Game.find(params[:id])
    respond_to do |format|
      format.html {
        send_data(`cat #{File.join(RAILS_ROOT, 'public', 'images', game.world_id.to_s)}.png`,
                  :type => 'image/png', :disposition => 'inline') 
      }
      format.js do
        world.to_js
      end
    end

  end

end
