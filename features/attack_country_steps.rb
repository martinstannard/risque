Given /^there is an attacking country$/ do
  @attacker = GamePlayerCountry.make
end

Given /^there is a defending country$/ do
  @defender = GamePlayerCountry.make
end

When /^the player attacks with (\d+) armies$/ do |a|
  @attacker.armies = a
  @attacker.save
  @result = @attacker.country.attack(@defender.country, a.to_i)
end

Then /^the result should be a string containing (\d+)/ do |a|
  @result.should match(/#{a} attacking armies/)
end


