class Country < ActiveRecord::Base

  belongs_to :region
  has_many :neighbours, :dependent => :destroy
  has_one :game_player_country
  has_one :game_player, :through => :game_player_country

  def label
    label = "country_#{id}" 
    label << "_#{game_player_country.armies}" if game_player_country
  end

  def attack(target, attacker_dice = 1, defender_dice = 1)
    results = roller(attacker_dice, defender_dice)
    results.each do |r|
      r ?  target.game_player_country.add_armies(-1) : game_player_country.add_armies(-1)
    end
  end

  protected

  def roller(attacker_rolls = 1, defender_rolls = 1)
    attack_die = (0...attacker_rolls).collect { |r| dice }.sort[0...defender_rolls].flatten
    defend_die = (0...defender_rolls).collect { |r| dice }.sort.flatten
    puts "#{attack_die} - #{defend_die}"
    results = []
    defender_rolls.times { |r| results << (attack_die[r] > defend_die[r]) }
    results
  end

  def dice
    rand(6) + 1
  end

end
