Given /^a region exists$/ do
  @region = Region.make
end

Then /^the region should contain at least 2 countries$/ do
  @region.countries.count.should >= 2
end

Then /^the region should have a name$/ do
  @region.name.should_not be_nil
end

