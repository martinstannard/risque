class World < ActiveRecord::Base

  has_many :regions, :dependent => :destroy

  after_create :generate_regions

  @@colours = %w[lightblue red green orange yellow pink blue violet]

  def self.begat
    World.destroy_all
    World.create
    Neighbour.graph
  end

  def generate_regions
    7.times do |t|
      puts "generation region #{t}"
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
