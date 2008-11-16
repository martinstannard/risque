Given /^is at battle strength is (\d+),(\d+)$/ do |a, b|
  @country = Country.make
  @at = a.to_i
  @de = b.to_i
end

When /^the country rolls the dice$/ do
  @result = @country.roller(@at, @de)
end

Then /^the result length should be (\d+)$/ do |res|
  @result.size.should == res.to_i
end

