def trip_area_element(area)
  case area
  when "Want to join"
    find(".want-to-join-users")
  when "Trip users"
    find("#trip_users")
  end
end

Given /^I visit trip page$/ do
  visit trip_path(Trip.first.id)
end

When /^I click "(.*?)" button$/ do |button|
  click_button(button)
end

Then /^I should see my name in "(.*?)" area$/ do |area|
  trip_area_element(area).should  have_content(@visitor[:name])
end

Then /^I should see "(.*?)" link in "(.*?)" area$/ do |link, area|
  trip_area_element(area).should  have_link(link)
end

Then /^I should see "(.*?)" icon in "(.*?)" area$/ do |icon, area|
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