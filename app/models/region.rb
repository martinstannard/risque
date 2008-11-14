class Region < ActiveRecord::Base

  belongs_to :world
  has_many :countries, :dependent => :destroy

  after_create :generate_countries

  def generate_countries(options = {})
    options[:min] ||= 4
    options[:max] ||= 10
    (rand(options[:max] - options[:min]) + options[:max]).times do |t|
      puts "generating country #{t}" 
      countries << Country.create(:name => "country_#{t}")
    end
    create_borders
    update_attribute(:bonus, countries.size - 2)
  end

  def rand_country
    countries[rand(countries.size)]
  end

  def rand_other_country(country)
    (countries - [country])[rand(countries.size - 1)]
  end

  def border
    country = rand_country
    Neighbour.create(:country_id => country.id, :neighbour_id => self.rand_other_country(country).id)
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
