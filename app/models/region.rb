class Region < ActiveRecord::Base

  belongs_to :world
  has_many :countries, :dependent => :destroy

  after_create :generate_countries

  def generate_countries
    (rand(6)+4).times do |t|
      puts "generating country #{t}" 
      countries << Country.create(:name => "country_#{t}")
    end
    create_borders
    update_attribute(:bonus, countries.size - 2)
  end

  def rand_country
    countries[rand(countries.size)]
  end

  def border
    Neighbour.create(:country_id => rand_country.id, :neighbour_id => rand_country.id)
  end

  def create_borders
    countries.each do |c|
      other_countries = countries.dup - [c]
      border_count = rand(2) + 1
      border_count.times do
        border
      end
    end
  end

end
