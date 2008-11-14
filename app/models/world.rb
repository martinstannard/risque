class World < ActiveRecord::Base

  has_many :regions

  after_save :generate_regions

  def generate_regions
    puts "generate regions"
    7.times do
      regions << Region.create
    end
  end

end
