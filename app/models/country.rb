class Country < ActiveRecord::Base

  belongs_to :region
  has_many :neighbours, :dependent => :destroy
  has_one :game_player_country
  has_one :game_player, :through => :game_player_country

  def label
    label = %Q{"#{name}}
    label << %Q{ #{game_player_country.armies} armies} unless game_player_country.nil?
    label << '"'
    label
  end

  def to_dot(options = {})
   "#{label} [shape=#{region.shape}, color=#{colour(options[:mode])},style=filled];"
  end

  def attack(target, attacker_dice = 1, defender_dice = 1)
    strengths = battle_strengths(attacker_dice, target)
    logger.info "battle_strengths [#{strengths}]"
    results = roller(*strengths)
    attackers_left = kill_armies(target, results)
    logger.info "attackers_left [#{attackers_left}]"
    invaders = attacker_dice - (strengths[0] - attackers_left)
    logger.info "invading with [#{invaders}]"
    if takeover(target, invaders)
      return "You defeated the enemy. You have overrun their territory."
    else
      return "You could not defeat the infidels - better luck next time."
    end
  end

  def kill_armies(target, results)
    results.each do |r|
      r ? target.game_player_country.add_armies(-1) : game_player_country.add_armies(-1)
    end
    results.find_all { |r| r }.size
  end

  def takeover(target, invaders)
    # has the target been vanquished
    if target.game_player_country.armies == 0
      target.game_player_country.update_attribute(:game_player_id, self.game_player.id)
      target.game_player_country.add_armies(invaders)
      game_player_country.add_armies(-invaders)
      return true
    end
    false
  end

  def colour(mode)
    return region.colour if mode == :region
    return game_player.colour if game_player
    'white'
  end

  def battle_strengths(attacker_dice, defender)
    target_armies = defender.game_player_country.armies
    if attacker_dice <= target_armies
      return [attacker_dice, (attacker_dice == 1) ? attacker_dice : attacker_dice - 1]
    else
      return [target_armies + 1, target_armies]
    end
  end

  def roller(attacker_rolls = 1, defender_rolls = 1)
    attack_die = (0...attacker_rolls).collect { |r| dice }.sort.reverse
    #.sort.reverse[0...defender_rolls].flatten
    defend_die = (0...defender_rolls).collect { |r| dice }.sort.reverse
    logger.info "#{attack_die.join(',')} #{defend_die.join(',')}"
    attack_die = attack_die[0...defend_die.size]
    logger.info "#{attack_die.join(',')} #{defend_die.join(',')}"
    results = []
    defend_die.size.times { |r| results << (attacker_wins?(attack_die[r], defend_die[r])) }
    logger.info results
    results
  end

  def attacker_wins?(attack_die, defence_die)
    attack_die > defence_die
  end

  def deploy(army_count)
    update_attribute(:armies, armies + army_count)
  end

  protected

  def dice
    rand(6) + 1
  end

end
