class Neighbour < ActiveRecord::Base

  belongs_to :country
  belongs_to :neighbour, :class_name => 'Country'

  def self.graph(file_prefix = 'world')
    text = ["digraph world {"]
    text << "graph [fontname = \"Helvetica\","
    text << "fontsize = 36,"
    text << "label = \"Risque, #{Date.today}\"]"
    y Neighbour.all
    Neighbour.all.each do |n|
      c = n.country
      rel = "#{c.label} -> country_#{n.neighbour.id};\n"
      rel << "#{c.label} [shape=rectangle,color=#{c.region.colour},style=filled];\n"
      puts rel
      text << rel
    end
    text << "}"
    File.open("#{file_prefix}.dot", 'w') do |f|
      f << text.uniq.join("\n")
    end
    #`dot -Tpng -Gsize=6,6 -o#{file_prefix}.png "#{file_prefix}.dot"`
  end

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

end
