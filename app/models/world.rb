# == Schema Information
# Schema version: 20081119013232
#
# Table name: worlds
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class World < ActiveRecord::Base

  has_many :regions, :dependent => :destroy, :include => :countries

  after_create :generate_regions

  @@colours = %w[lightblue red green orange yellow pink blue violet]
  @@shapes = %w[box polygon ellipse trapezium parallelogram house hexagon pentagon]

  def self.begat
    World.destroy_all
    w = World.create
    w
  end

  def graph(options = {})
    options[:mode] ||= :region
    text = ["graph world {"]
    text << "graph [fontname = \"Helvetica\","
    text << "bgcolor=black, nodesep=.05, fontsize = 50, overlap = scale, ratio = 0.5, labelfontsize=30]"

    regions.each do |region|
      text << "subgraph #{region.label}{"
      text << "  node [style=\"filled, bold, rounded\", border=\"black\"];"
      region.countries.each { |c| text << c.to_dot }
      text << "label=\"#{region.label}a\";\ncolor=blue\n}\n"
      region.internal_borders.each { |border| text << border.to_dot }
      region.external_borders.each { |border| text << border.to_dot }
    end
    text << "}\n"
    text.uniq!
    File.open(File.join(RAILS_ROOT, 'tmp', "#{id}.dot"), 'w') do |f|
      f << text.join("\n")
    end
    `dot -Tpng -Gsize=12,12 -o#{File.join(RAILS_ROOT, 'public', 'images', id.to_s)}.png #{File.join(RAILS_ROOT, 'tmp', id.to_s)}.dot` unless RAILS_ENV == 'testing'
  end

  def award_armies(game_player)
    game_player.add_armies(game_player.countries.size / 3)
    #TODO award_bonuses game_player
  end

  protected

  def award_bonuses(game_player)
    regions.each { |r| r.award_bonuses(game_player) }
  end

  def generate_regions(options = {})
    options[:min] ||= 2
    options[:max] ||= 4
    (rand(options[:max] - options[:min]) + options[:min]).times do |t|
      regions << Region.create(:name => "region_#{t}", :colour => colours(t), :shape => shapes(t))
    end
    countries = SimpleConfig.for(:application).countries.dup.sort_by { rand }
    regions.collect {|r| r.countries }.flatten.each_with_index {|c, i| c.update_attribute(:name, countries[i]) }
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
