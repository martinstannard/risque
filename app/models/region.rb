# == Schema Information
# Schema version: 20081119013232
#
# Table name: regions
#
#  id         :integer(4)      not null, primary key
#  world_id   :integer(4)
#  name       :string(255)
#  bonus      :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  colour     :string(255)     default("")
#  shape      :string(255)
#

class Region < ActiveRecord::Base

  belongs_to :world
  has_many :countries, :dependent => :destroy

  def label
    name
  end

  def generate_countries(options = {})
    options[:min] ||= 4
    options[:max] ||= 10
    (rand(options[:max] - options[:min]) + options[:min]).floor.times do |t|
      countries << Country.create
      logger.info "*" * 100
      logger.info countries.last.inspect
    end
    create_borders
    update_attribute(:bonus, countries.size - 2)
  end

  def rand_country
    countries[rand(countries.size)]
  end

  def rand_other_country(country)
    (countries - [country])[rand(countries.size - 1)]
  end

  def border
    country = rand_country
    Neighbour.create_borders(country.id, self.rand_other_country(country).id)
  end

  def create_borders
    2.times do
      countries.each do |c|
        other_countries = countries.dup - [c]
        border_count = rand(3) + 1
        border_count.times do
          border
        end
      end
    end
  end

  def borders
    countries.collect { |c| c.neighbours }.flatten
  end
  
  def internal_borders
    borders.select { |n| n.is_regional? }
  end

  def external_borders
    borders.select { |n| !n.is_regional? }
  end

  def award_bonuses(game_player)
    if bonus?
      player = countries.first.game_player
      player.add_armies(bonus) if game_player == player
    end
  end

  protected

  def bonus?
    countries.collect { |c| c.game_player }.uniq.size == 1
  end

end
