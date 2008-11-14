class Region < ActiveRecord::Base

  belongs_to :world
  has_many :countries

  after_create :generate_countries

  def generate_countries
    (rand(6)+4).times do |t|
      puts "generating country #{t}" 
      countries << Country.create(:name => "country_#{t}")
    end
    update_attribute(:bonus, countries.size - 2)
  end
  
end
