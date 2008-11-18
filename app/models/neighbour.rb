class Neighbour < ActiveRecord::Base

  belongs_to :country
  belongs_to :neighbour, :class_name => 'Country'

  def self.create_borders(country_id, neighbour_id)
    Neighbour.create(:country_id => country_id, :neighbour_id => neighbour_id) unless border_exists?(country_id, neighbour_id)
    Neighbour.create(:country_id => neighbour_id, :neighbour_id => country_id) unless border_exists?(neighbour_id, country_id)
  end

  def self.border_exists?(country_id, neighbour_id)
    exists?(['country_id = ? AND neighbour_id = ?', country_id, neighbour_id])
  end

  def is_regional?
    Country.find(country_id).region == Country.find(neighbour_id).region
  end

  def to_dot
    [country.label, neighbour.label].sort.join(' -- ') + " [color=white];"
  end

end
