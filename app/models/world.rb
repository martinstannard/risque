class World < ActiveRecord::Base

  has_many :regions, :dependent => :destroy

  after_create :generate_regions

  @@colours = %w[lightblue red green orange yellow pink blue violet]

  def self.begat
    World.destroy_all
    w = World.create
    w.graph
    w
  end

  def graph(options = {})
    options[:mode] ||= :region
    text = ["digraph world {"]
    text << "graph [fontname = \"Helvetica\","
    text << "fontsize = 36,"
    text << "ratio = 0.6,"
    text << "label = \"Risque, #{Date.today}\"]"
    regions.each do |region|
      text << " node[style=filled];\n"
      text << "subgraph #{region.label}{\n"
      region.internal_borders.each do |n|
        c = n.country
        text << "#{c.label} -> #{n.neighbour.label};\n"
        text << "#{c.label} [shape=rectangle,color=#{c.colour(options[:mode])},style=filled];\n"
      end
      text << "label=\"#{region.label}a\";\ncolor=blue\n}\n"
      region.external_borders.each do |n|
        c = n.country
        text << "#{c.label} -> #{n.neighbour.label};\n"
        text << "#{c.label} [shape=rectangle,color=#{c.colour(options[:mode])},style=filled];\n"
      end
    end
    text << "}\n"
    File.open("#{id}.dot", 'w') do |f|
      f << text.uniq.join("\n")
    end
    `dot -Tpng -Gsize=12,12 -o#{File.join(RAILS_ROOT, 'public', 'images', id.to_s)}.png "#{id}.dot"` unless RAILS_ENV == 'testing'
  end

  def award_armies(game_player)
    game_player.add_armies(game_player.countries.size / 3)
    #TODO award_bonuses game_player
  end

  protected

  def award_bonuses(game_player)
    regions.each { |r| r.add_bonuses(game_player) }
  end

  def generate_regions(options = {})
    options[:min] ||= 2
    options[:max] ||= 4
    (rand(options[:max] - options[:min]) + options[:min]).times do |t|
      regions << Region.create(:name => "region_#{t}", :colour => @@colours[t])
    end
    create_borders
  end

  def create_borders
    # backbone between all regions
    regions[0..-2].each_with_index do |region, i|
      Neighbour.create_borders(region.rand_country.id, regions[i + 1].rand_country.id)
    end
    regions.each do |region|
      country = region.countries[rand(region.countries.size)]
      other_region = regions[rand(regions.size)]
      other_country = other_region.countries[rand(other_region.countries.size)]
      Neighbour.create_borders(country.id, other_country.id)
    end
  end

end
