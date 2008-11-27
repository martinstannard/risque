require File.dirname(__FILE__) + '/../spec_helper'

describe Country, "can has armies" do

  before do
    @country = Country.make
  end

  it "should have no armies initially" do
    @country.armies.should == 0
  end

  it "should have 10 armies if added" do
    @country.add_armies(10)
    @country.armies.should == 10
  end

  it "should have 30 armies if added" do
    @country.add_armies(10)
    @country.add_armies(20)
    @country.armies.should == 30
  end

end

describe Country, "should have a to_svg method" do

  before do
    @country = Country.make
  end

  it "should have coordinates" do
  end

end
