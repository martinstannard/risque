  class World < ActiveRecord::Base

    has_many :regions, :dependent => :destroy

    after_create :generate_regions

    def generate_regions
      7.times do |t|
        puts "generation region #{t}"
        regions << Region.create(:name => "region_#{t}")
      end
      create_borders
    end

    def create_borders
      regions.each do |region|
        country = region.countries[rand(region.countries.size)]
        other_region = regions[rand(regions.size)]
        other_country = other_region.countries[rand(other_region.countries.size)]
        Neighbour.create(:country_id => country.id, :neighbour_id => other_country.id)  
      end
    end

  end
