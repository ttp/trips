Then /^I should see Comments form$/ do
  trip_area_element("Comments").should have_selector("textarea")
end

When /^I enter "(.*?)" to Comments form$/ do |text|
  fill_in "comment", :with => text
end

When /^I click "(.*?)" button in Comments form$/ do |button|
  trip_area_element("Comments").click_button(button)
end