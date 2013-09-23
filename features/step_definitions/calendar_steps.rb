
# GIVEN
Given /^I am on calendar page$/ do
  visit "/calendar"
end

Given /^I have "(\d+)" trips? in "(\w+)"$/ do |num, region_name|
  user = FactoryGirl.create(:user)
  region = Region.find_by_name(region_name)
  track = FactoryGirl.create(:track, {region: region, user: user})
  num.to_i.times do
    FactoryGirl.create(:trip, {track: track, user: user})
  end
end

# WHEN
When(/^I click "(.*?)" in filers$/) do |region|
  page.first("#filters").find("input[value='#{region}']").set(true)
end

When(/^I click backpacker icon$/) do
  find('td.start-day').click
end

When(/^I close trips list$/) do
  find("#trips button.close").click
end

# THEN
Then(/^I should see filters list$/) do
  find("#filters").visible?.should == true
end

Then /^I should see "(\w+)" in filters$/ do |region|
  page.first("#filters").should have_content(region)
end

Then(/^I should see "(.*?)" trips in calendar$/) do |num|
  events = 0
  all("#calendar .events-count").each do |cnt_el|
    events += cnt_el.text.to_i
  end
  
  events.should == num.to_i
end

Then(/^I should see backpacker icon$/) do
  page.should have_selector("td.start-day .day-wrapper")
end

Then(/^I should see list of trips with "(.*?)" trips$/) do |num|
  find("#trips").visible?.should == true
  page.should have_css("#trips .trip", :count => num.to_i)
end