require File.dirname(__FILE__) + '/../spec_helper'

describe World, "can has regions" do

  before do
    @w = World.make
    @w.generate_regions({:min => 3, :max => 3}, {:min => 3, :max => 3})
  end

  it "should have 3 regions" do
    @w.regions.size.should == 3
  end

  it "should have 9 countries" do
    @w.send(:countries).size.should == 9
  end

end

