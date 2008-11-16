When /^the attacker tried to takeover the defender$/ do
  @result = @attacker.takeover(@defender, 10)
end

Then /^the takeover should succeed$/ do
  @result.should === true
end

Then /^the target should have 10 armies moved into it$/ do
  @defender.game_player_country.armies.should == 10
end
    
Then /^the target should be owned by the attacker$/ do
  @defender.game_player_country.game_player.should == @attacker.game_player_country.game_player
end
  
