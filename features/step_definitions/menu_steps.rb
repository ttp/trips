Given /^I have "(.*?)"( public)? Menus? for "(.*?)" days$/ do |menu_cnt, is_public, days_cnt|
  menu_cnt.to_i.times do
    FactoryGirl.create(:menu, {is_public: !is_public.nil?})
  end
end

Given /^I am on Menu page$/ do
  visit menus_path
end

Then /^I should see "(.*?)" Menus in Menu list$/ do |num|
  page.should have_css(".menu-item", :count => num.to_i)
end