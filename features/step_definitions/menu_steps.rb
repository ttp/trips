Given /^I have "(.*?)"( not empty)?( private)? Menu$/ do |menu_name, not_empty, is_private|
  factory = not_empty.nil? ? :menu : :menu_with_days
  FactoryGirl.create(factory, {name: menu_name, is_public: is_private.nil?})
end

Given /^I am on Menus page$/ do
  visit menus_path
end

Then /^I should see "(.*?)" Menus in Menu list$/ do |num|
  page.should have_css(".menu-item", :count => num.to_i)
end

Then /^I should see menu entities$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see menu summary$/ do
  pending # express the regexp above with the code you wish you had
end
