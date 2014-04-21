Given(/^I have "(.*?)" categories with "(.*?)" products$/) do |categories_cnt, products_cnt|
  categories = FactoryGirl.create_list(:menu_product_category, categories_cnt.to_i)
  categories.each do |category|
    FactoryGirl.create_list(:menu_product, products_cnt.to_i, product_category: category)
  end
end

When(/^I visit products page$/) do
  visit menu_products_path
end

Then(/^I should see "(.*?)" categories$/) do |cnt|
  page.should have_css("#categories li a", count: cnt.to_i)
end

Then(/^I should see "(.*?)" products$/) do |cnt|
  page.should have_css("#products .product", count: cnt.to_i)
end

And(/^I click first category link$/) do
  page.find('#categories li:first-child a').click
end

Then(/^I should not see "(.*?)" link$/) do |link|
  page.should_not have_link(link)
end


Given(/^I fill in "(.*?)" product for "(.*?)"$/) do |name, category_name|
  category = Menu::ProductCategory.find_by(name: category_name)
  product = FactoryGirl.build(:menu_product, name: name, product_category: category)

  fill_in "menu_product_name", with: product.name
  select category_name, from: "menu_product_product_category_id"
  fill_in "menu_product_calories", with: product.calories
  fill_in "menu_product_proteins", with: product.proteins
  fill_in "menu_product_fats", with: product.fats
  fill_in "menu_product_carbohydrates", with: product.carbohydrates
end

Then(/^I should be on products page$/) do
  current_path = URI.parse(current_url).path
  current_path.should == menu_products_path
end

Then(/^I should see "(.*?)" in products$/) do |name|
  page.should have_content(name)
end

Given(/^I have "(.*?)" category$/) do |name|
  FactoryGirl.create(:menu_product_category, name: name)
end