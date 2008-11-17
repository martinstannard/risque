When /^(\d+) of (\d+) attacks succeed$/ do |success, total|
  deaths = [true] * success + (all - count) * [false]
  @attacker.kill_armies(@defender, deaths)
end

Then /^then attacker should have (\d+) armies left$/ do |d|
  @attacker.game_player_country.armies.should == d.to_i
end

Then /^then defender should have (\d+) armies left$/ do |d|
  @defender.game_player_country.armies.should == d.to_i
end

Then /^the defender should be owned by the attacker$/ do
  @defender.game_player_country.game_player.should == @attacker.game_player_country.game_player
end
