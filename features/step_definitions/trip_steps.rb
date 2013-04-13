def trip_area_element(area)
  case area
  when "Trip users"
    find("#trip_users")
  when "Joined users"
    find("#trip_users .trip-users")
  when "Want to join"
    find("#trip_users .want-to-join-users")
  end
end

Given /^I visit trip page$/ do
  visit trip_path(Trip.first.id)
end

Given /^Trip has join request for user "(.*?)"$/ do |name|
  user = FactoryGirl.create(:user, {:name => name})
  trip = Trip.first
  FactoryGirl.create(:trip_user, {trip: trip, user: user})
end

When /^I click "(.*?)" button$/ do |button|
  click_button(button)
end

Then /^I should( not)? see my name in "(.*?)" trip area$/ do |negate, area|
  area = trip_area_element(area)
  negate ? area.should_not(have_content(@visitor[:name])) : area.should(have_content(@visitor[:name]))
end

Then /^I should see "(.*?)" link in "(.*?)" trip area$/ do |link, area|
  trip_area_element(area).should  have_link(link)
end

Then /^I should see "(.*?)" icon in "(.*?)" trip area$/ do |icon, area|
  trip_area_element(area).should  have_selector('a.' + icon.downcase)
end

Then /^I should see "(.*?)" button$/ do |button|
  page.should have_button(button)
end

Then /^Trip owner should receive an email with subject "(.*?)"$/ do |subject|
  email = Trip.first.user.email
  steps %Q{
    Then "#{email}" should receive an email with subject "#{subject}"
  }
end

When /^I click "(.*?)" icon$/ do |icon|
  find("a." + icon.downcase).click
end

When /^I accept confirm dialog$/ do
  page.driver.browser.switch_to.alert.accept
end

When /^I sign in as trip owner$/ do
  user = Trip.first.user
  sign_in_as(user)
end

Then /^I should( not)? see "(.*?)" in "(.*?)" trip area$/ do |negate, text, area|
  area = trip_area_element(area)
  negate ? area.should_not(have_content(text)) : area.should(have_content(text))
end

Then /^user "(.*?)" should receive an email with subject "(.*?)"$/ do |name, subject|
  email = User.find_by_name(name).email
  steps %Q{
    Then "#{email}" should receive an email with subject "#{subject}"
  }
end