class World < ActiveRecord::Base

  has_many :regions

  after_create :generate_regions

  def generate_regions
    7.times do |t|
      puts "generation region #{t}"
      regions << Region.create(:name => "region_#{t}")
    end
  end

end
