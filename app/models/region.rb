class Region < ActiveRecord::Base

  belongs_to :world
  has_many :countries

  after_create :generate_countries

  def generate_countries
    7.times do
      countries << Country.create
    end
  end
  
end
