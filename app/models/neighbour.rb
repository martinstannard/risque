class Neighbour < ActiveRecord::Base

  belongs_to :country

  def self.graph(file_prefix = 'world')
    text = ["digraph world {"]
    text << "graph [fontname = \"Helvetica\","
    text << "fontsize = 36,"
    text << "label = \"#{name}, #{Date.today}\"]"
    y Neighbour.all
    Neighbour.all.each do |n|
      country = n.country
      #country.neighbours.each do |neighbour|
        rel = "\"Country #{n.country_id}\" -> \"Country #{n.neighbour_id}\";\n"
        puts rel
        text << rel
      #end
    end
    text << "}"
    File.open("#{file_prefix}.dot", 'w') do |f|
      f << text.uniq.join("\n")
    end
    `dot -Tpng -Gsize=6,6 -o#{file_prefix}.png "#{file_prefix}.dot"`
  end

end
