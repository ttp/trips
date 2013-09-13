Given /^I have "(.*?)"( not empty)?( private)? Menu$/ do |menu_name, not_empty, is_private|
  factory = not_empty.nil? ? :menu : :menu_with_days
  FactoryGirl.create(factory, {name: menu_name, is_public: is_private.nil?})
end

Given /^I am on Menus page$/ do
  visit menu_menus_path
end

Then /^I should see "(.*?)" Menus in Menu list$/ do |num|
  page.should have_css(".menu-item", :count => num.to_i)
end

Then /^I should see menu entities$/ do
  page.should have_css(".day", :count => 3)
  days = 3
  meals = 3 * days
  dishes = 2 * meals
  products = 3 * dishes
  page.should have_css(".entity", :count => meals + dishes + products)
end

Then /^I should see menu summary$/ do
  pending # express the regexp above with the code you wish you had
end
