Given /^there is an attacking country with (\d+) armies$/ do |a|
  @attacker = GamePlayerCountry.make(:armies => a).country
end

Given /^the defending country has (\d+) armies$/ do |a|
  @defender = GamePlayerCountry.make(:armies => a).country
end

When /^the player attacks with (\d+) dice$/ do |a|
  strs = @attacker.battle_strengths(a, @defender)
end

Then /^the battle strengths should be (\d+), (\d+)$/ do |a, d|
  strs = [a, d]
end

