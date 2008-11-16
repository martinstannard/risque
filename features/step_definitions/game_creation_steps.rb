Given /^there are no games yet$/ do
end

Given /^there are (\d+) players$/ do |player_count|
  player_count.to_i.times { Player.make }
end

When /^I press the begat world button$/ do
  post games_path
end

Then /^there should be 1 game created$/ do
  Game.count.should == 1
  @game = Game.first
end

Then /^the game should have a world$/ do
  @game.world.should_not be_nil
end


