
require File.dirname(__FILE__) + '/../spec_helper'

describe Country, "can has armies" do

  before do
    @country = Country.make
  end

  it "should have no armies initially" do
    @country.armies.should == 0
  end

  it "should have 10 armies if added" do
    @country.deploy(10)
    @country.armies.should == 10
  end

  it "should have 20 armies if added" do
    @country.deploy(10)
    @country.deploy(20)
    @country.armies.should == 10
  end

end

