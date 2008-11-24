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

  def self.begat
    World.destroy_all
    w = World.create
    w
  end

  def graph(options = {})
    to_dot
    `dot -Tpng -Gsize=12,12 -o#{File.join(RAILS_ROOT, 'public', 'images', id.to_s)}.png #{File.join(RAILS_ROOT, 'tmp', id.to_s)}.dot` unless RAILS_ENV == 'testing'
  end

  def award_armies(game_player)
    game_player.add_armies(game_player.countries.size / 3)
    #TODO award_bonuses game_player
  end

  def to_js
    text = %Q[function draw_map() {var paper = Raphael("holder", 800, 800);\n]
    countries.each_with_index do |c, i|
      text << %Q[var c_#{i} = paper.circle(#{c.x_position}, #{c.y_position}, #{c.armies * 5 + 10});\n c_#{i}.attr("fill", "##{c.game_player.colour.hex}");\n c_#{i}.attr("stroke", "#fff");\n]
      text << %Q[var attr = {"font": '16px "Verdana"', opacity: 0.8};\n paper.text(#{c.x_position}, #{c.y_position}, "#{c.x_position}, #{c.y_position}, #{c.name}").attr(attr).attr("fill", "#fff");\n]
    end
    text << '}'
    text
  end

  protected

  def countries
    regions.collect { |r| r.countries }.flatten
  end

  def set_coordinates
    to_dot
    out = File.join(RAILS_ROOT, 'tmp', id.to_s) + '.txt'
    `dot -Tplain -Gsize=12,12 -o#{out} #{File.join(RAILS_ROOT, 'tmp', id.to_s)}.dot` unless RAILS_ENV == 'testing'
    i  = 0
    File.open(out).each do |line|
      line =~ /node (\d+)  (\d+\.\d+) (\d+\.\d+)/
        if $1
          x = ($2.to_f*90).to_i
          y = ($3.to_f*90).to_i
          c = Country.find($1)
          c.update_attributes(:x_position => x, :y_position => y)
          i += 1
        end
    end
  end

  def to_dot
    text = ["graph world {"]
    text << "graph [fontname = \"Helvetica\","
    text << "bgcolor=black, nodesep=.05, fontsize = 50, overlap = scale, ratio = 0.9, labelfontsize=30]"

    regions.each do |region|
      text << "subgraph #{region.label}{"
      text << "  node [style=\"filled, bold, rounded\", border=\"black\"];"
      region.countries.each { |c| text << c.to_dot }
      text << "label=\"#{region.label}a\";\ncolor=blue\n}\n"
    end
    regions.collect {|r| r.countries}.flatten.each { |c| c.neighbours.each {|b| text << b.to_dot } }
    text << "}\n"
    text.uniq!
    File.open(File.join(RAILS_ROOT, 'tmp', "#{id}.dot"), 'w') do |f|
      f << text.join("\n")
    end
  end

  def award_bonuses(game_player)
    regions.each { |r| r.award_bonuses(game_player) }
  end

  def generate_regions(options = {})
    options[:min] ||= 2
    options[:max] ||= 4
    (rand(options[:max] - options[:min]) + options[:min]).times do |t|
      regions << Region.create(:name => "region_#{t}")
    end
    countries = SimpleConfig.for(:application).countries.dup.sort_by { rand }
    regions.collect {|r| r.countries }.flatten.each_with_index {|c, i| c.update_attribute(:name, countries[i]) }
    create_borders
    to_dot
    set_coordinates
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
