class Country < ActiveRecord::Base
  
  belongs_to :region
  has_many :neighbours, :dependent => :destroy

  def label
    "country_#{id}"
  end

end
