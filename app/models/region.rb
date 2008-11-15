class Region < ActiveRecord::Base

  belongs_to :world
  has_many :countries, :dependent => :destroy

  after_create :generate_countries
  
  def label
    name
  end

  def generate_countries(options = {})
    options[:min] ||= 4
    options[:max] ||= 10
    (rand(options[:max] - options[:min]) + options[:min]).times do |t|
      puts "generating country #{t}" 
      countries << Country.create(:name => "country_r#{self.id}_c#{t}")
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
    Neighbour.create_borders(country.id, self.rand_other_country(country).id)
  end

  def create_borders
    countries.each do |c|
      other_countries = countries.dup - [c]
      border_count = rand(3) + 1
      border_count.times do
        border
      end
    end
  end

  def borders
    countries.collect { |c| c.neighbours }.flatten
  end
  
  def internal_borders
    borders.select { |n| n.is_regional? }
  end

  def external_borders
    borders.select { |n| !n.is_regional? }
  end

  def bonus?
    countries.collect { |c| c.game_player }.uniq.size == 1
  end

end
