require File.dirname(__FILE__) + '/../spec_helper'

describe GamePlayer, "can has armies" do

  before do
    @game_player = GamePlayer.make
  end

  it "should have no armies to allocate initially" do
    @game_player.armies_to_allocate.should == 0
  end

  it "should have 10 armies if added" do
    @game_player.add_armies(10)
    @game_player.armies_to_allocate.should == 10
  end

  it "should have 30 armies if added" do
    @game_player.add_armies(10)
    @game_player.add_armies(20)
    @game_player.armies_to_allocate.should == 30
  end

end

describe GamePlayer, "has armed countries" do

  before do
    @game_player = GamePlayer.make
  end

  it "should have no armed countries if it has no countries" do
    @game_player.armed_countries.size.should == 0
  end

end
