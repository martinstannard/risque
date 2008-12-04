# == Schema Information
# Schema version: 20081119013232
#
# Table name: countries
#
#  id             :integer(4)      not null, primary key
#  region_id      :integer(4)
#  name           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  armies         :integer(4)      default(0)
#  game_player_id :integer(4)
#

class Country < ActiveRecord::Base

  belongs_to :region
  belongs_to :game_player, :include => :colour
  has_many :neighbours, :dependent => :destroy

  def label
    label = %Q{"#{name}}
    label << %Q{ #{armies} armies} unless game_player.nil?
    label << '"'
    label
  end

  def to_dot(options = {})
    %Q(#{id} [color="#{colour}",style=filled,label="#{name}"];)
  end

  def to_js
      text = %Q[countries[#{id}] = paper.circle(#{x_position}, #{y_position}, #{(Math::log(armies.to_f) + 1) * 10});\n]
      text << unhighlight
      text << %Q[var attr = {"font": '12px "Verdana"', opacity: 0.8};\narmies[#{id}] = paper.text(#{x_position}, #{y_position - 20}, "#{name}").attr(attr).attr("fill", "#0f0");\n]
      text << %Q[var attr = {"font": '20px "Verdana"', opacity: 0.8};\narmies[#{id}] = paper.text(#{x_position}, #{y_position + 7}, "#{armies}").attr(attr).attr("fill", "#fff");\n]
      text
  end

  def highlight
    %Q[countries[#{id}].attr("fill", "#000");\n countries[#{id}].attr("stroke", "#f00");\n countries[#{id}].attr("stroke-width", "20");\n]
  end

  def unhighlight
    %Q[countries[#{id}].attr("fill", "#000");\n countries[#{id}].attr("stroke", "##{game_player.colour.hex}");\n countries[#{id}].attr("stroke-width", "20").attr("id", "#{id}");\n]
  end


  def attack(target, attacker_dice = 1, target_dice = 1)
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

  def colour(mode = :player)
    return "##{region.colour.hex}" if mode == :region
    return "##{game_player.colour.hex}" if game_player
    'white'
  end

  def add_armies(army_count)
    update_attribute(:armies, armies + army_count)
  end

  protected

  def battle_strengths(attacker_dice, target)
    target_armies = target.armies
    if attacker_dice <= target_armies
      return [attacker_dice, (attacker_dice == 1) ? attacker_dice : attacker_dice - 1]
    else
      return [target_armies + 1, target_armies]
    end
  end

  def roller(attacker_rolls = 1, target_rolls = 1)
    attack_die = (0...attacker_rolls).collect { |r| dice }.sort.reverse
    defend_die = (0...target_rolls).collect { |r| dice }.sort.reverse
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

  def kill_armies(target, results)
    results.each do |r|
      r ? target.add_armies(-1) : add_armies(-1)
    end
    results.find_all { |r| r }.size
  end

  def takeover(target, invaders)
    # has the target been vanquished
    if target.armies == 0
      target.update_attribute(:game_player_id, self.game_player.id)
      target.add_armies(invaders)
      add_armies(-invaders)
      return true
    end
    false
  end

  def dice
    rand(6) + 1
  end

end
