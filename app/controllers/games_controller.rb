class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def show
    
  end
  
  def create
    g = Game.create
    g.world.graph
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
    @neighbours = Country.find(params[:country_id]).neighbours
    @game_player_country = GamePlayerCountry.find(:first, :conditions =>["game_player_id = ? and country_id = ?",params[:game_player_id],params[:country_id]])
    @game_player = @game_player_country.game_player
    render :partial => "attack_target", :layout => false
  end

  def attack
    @game = Game.find(params[:game_id])
    @game_player = GamePlayer.find(params[:game_player_id])
    @game_player_attacking_country = GamePlayerCountry.find(:first, :conditions =>["country_id = ?",params[:attacker_country_id]])
    @game_player_target_country = GamePlayerCountry.find(:first, :conditions =>["country_id = ?",params[:target_country_id]])
    @armies = params[:armies].to_i
    
    report = @game_player_attacking_country.country.attack(@game_player_target_country.country,@armies)
    flash[:notice] = report
    logger.info report
    @game.world.graph(:mode => :player)
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
    @game_player_country = GamePlayerCountry.find(:first, :conditions =>["game_player_id = ? and country_id = ?",params[:game_player_id],params[:country_id]])
    @game_player_country.armies += params[:armies].to_i
    @game_player_country.save

    @game_player = @game_player_country.game_player
    @game_player.armies_to_allocate -= params[:armies].to_i
    @game_player.save

    @game = @game_player.game
    @game.world.graph(:mode => :player)

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
    send_data(`cat #{File.join(RAILS_ROOT, 'public', 'images', game.world_id.to_s)}.png`,
              :type => 'image/png', :disposition => 'inline') 
  end

end
