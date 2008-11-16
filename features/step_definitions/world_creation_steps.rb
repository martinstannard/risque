Given /^a world exists$/ do
  @world = World.make
end

Then /^the world should contain at least 2 regions$/ do
  @world.regions.count.should >= 2
end

Then /^the world should have a name$/ do
  @world.name.should_not be_nil
end

