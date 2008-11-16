Then /^then attacker should have (\d+) armies left$/ do |d|
  @attacker.game_player_country.armies.should == d.to_i
end

Then /^then defender should have (\d+) armies left$/ do |d|
  @defender.game_player_country.armies.should == d.to_i
end

When /^the killing is all on the defender$/ do
  @attacker.kill_armies(@defender, [true, true, true, true, true]).should == 10
end

When /^the killing is all on the attacker/ do
  @attacker.kill_armies(@defender, [false, false, false, false, false]).should == 5
end
