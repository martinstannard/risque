# == Schema Information
# Schema version: 20081119013232
#
# Table name: neighbours
#
#  id           :integer(4)      not null, primary key
#  country_id   :integer(4)
#  neighbour_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Neighbour < ActiveRecord::Base

  belongs_to :country, :include => :region
  belongs_to :neighbour, :class_name => 'Country', :include => :region

  def self.create_borders(country_id, neighbour_id)
    Neighbour.create(:country_id => country_id, :neighbour_id => neighbour_id) unless border_exists?(country_id, neighbour_id)
    Neighbour.create(:country_id => neighbour_id, :neighbour_id => country_id) unless border_exists?(neighbour_id, country_id)
  end

  def is_regional?
    Country.find(country_id).region == Country.find(neighbour_id).region
  end

  def to_dot
    [country_id, neighbour_id].sort.join(' -- ') + " [style=bold];"
  end

  def to_js
    %Q[paper.path({stroke: "##{colour}"}).moveTo(#{country.x_position}, #{country.y_position}).lineTo(#{neighbour.x_position}, #{neighbour.y_position});\n]
  end

  protected

  def colour
    (country.game_player.player.name == neighbour.game_player.player.name) ? country.game_player.colour.hex : 'fff'
  end

  def self.border_exists?(country_id, neighbour_id)
    exists?(['country_id = ? AND neighbour_id = ?', country_id, neighbour_id])
  end

end
