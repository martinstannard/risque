Given /^a country exists$/ do
  @country = Country.make
end

Then /^the country should contain at least 2 regions$/ do
  @country.regions.count.should >= 2
end

Then /^the country should have a name$/ do
  @country.name.should_not be_nil
end

