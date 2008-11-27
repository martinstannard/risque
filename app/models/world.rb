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

  def self.begat
    World.destroy_all
    w = World.create
    w.generate_regions
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
    text = %Q[function draw_map() {var paper = Raphael("holder", 1150, 600);\n]
    countries.collect { |c| c.neighbours }.flatten.each_with_index do |n, i|
      text << n.to_js
    end
    countries.each_with_index do |c, i|
      text << c.to_js(i)
    end
    text << '}'
    text
  end

  def generate_regions(options = {}, country_options = {})
    options[:min] ||= 2
    options[:max] ||= 4
    (rand(options[:max] - options[:min]) + options[:min]).floor.times do |t|
      regions << Region.create(:name => "region_#{t}")
      regions[-1].generate_countries(country_options)
    end
    countries = SimpleConfig.for(:application).countries.dup.sort_by { rand }
    regions.collect {|r| r.countries }.flatten.each_with_index {|c, i| c.update_attribute(:name, countries[i]) }
    create_borders
    set_coordinates
  end

  protected

  def countries
    regions.collect { |r| r.countries }.flatten
  end

  def set_coordinates
    to_dot
    out = File.join(RAILS_ROOT, 'tmp', id.to_s) + '.txt'
    `neato -Tplain -Gsize=1200,600 -o#{out} #{File.join(RAILS_ROOT, 'tmp', id.to_s)}.dot` unless RAILS_ENV == 'testing'
    i  = 0
    max_x = max_y = 0.0
    File.open(out).each do |line|
      line =~ /node (\d+)  (\d+\.\d+) (\d+\.\d+)/
        if $1
          max_x = $2.to_f if $2.to_f > max_x
          max_y = $3.to_f if $3.to_f > max_y
        end
    end
    scaling_x = 1000.0 / max_x
    scaling_y = 550.0 / max_y
    logger.info scaling_x,scaling_y
    File.open(out).each do |line|
      line =~ /node (\d+)  (\d+\.\d+) (\d+\.\d+)/
        if $1
          x = ($2.to_f * scaling_x).to_i + 25
          y = ($3.to_f * scaling_y).to_i + 25
          c = Country.find($1)
          c.update_attributes({:x_position => x, :y_position => y})
          i += 1
        end
    end
  end


  def to_dot
    text = ["graph world {"]
    text << "graph [fontname = \"Helvetica\","
    text << "bgcolor=black, nodesep=.05, fontsize = 50, overlap = scale, ratio = 0.5, labelfontsize=30]"

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
