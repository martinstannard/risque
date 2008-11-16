class Country < ActiveRecord::Base

  belongs_to :region
  has_many :neighbours, :dependent => :destroy
  has_one :game_player_country
  has_one :game_player, :through => :game_player_country

  @@colours = %w[lightblue red green orange yellow pink blue violet]

  def label
    label = "Country_#{id}_:_" 
    label << "#{game_player_country.armies}_armies" unless game_player_country.nil?
    label
  end

  def attack(target, attacker_dice = 1, defender_dice = 1)
    results = roller(attacker_dice, defender_dice)
    results.each do |r|
      r ?  target.game_player_country.add_armies(-1) : game_player_country.add_armies(-1)
    end
    attackers_left = results.find_all { |r| r }.size
    if takeover(target, attackers_left)
      return "You defeated the enemy. You have overrun their territory."
    else
      return "#{attackers_left} of #{attacker_dice} attacking armies survived."
    end
  end

  def takeover(target, attackers_left)
    # has the target been vanquished
    if target.game_player_country.armies == 0
      target.game_player_country.update_attribute(:game_player_id, self.game_player.id)
      target.game_player_country.update_attribute(:armies, attackers_left)
      return true
    end
    false
  end

  def colour(mode)
    mode == :region ? region.colour : @@colours[game_player.player_id % 4]
  end

  protected

  def roller(attacker_rolls = 1, defender_rolls = 1)
    attack_die = (0...attacker_rolls).collect { |r| dice }.sort[0...defender_rolls].flatten
    defend_die = (0...defender_rolls).collect { |r| dice }.sort.flatten
    results = []
    defender_rolls.times { |r| results << (attack_die[r] > defend_die[r]) }
    results
  end

  def dice
    rand(6) + 1
  end

end
