def comment_visible_form
  trip_area_element("Comments").find('form', visible: true)
end

When /^I enter "(.*?)" to Comments form$/ do |text|
  comment_visible_form.fill_in "comment", :with => text
end

When /^I click "(.*?)" button in Comments form$/ do |button|
  comment_visible_form.click_button(button)
end

When /^I click "(.*?)" icon in "(.*?)" trip area$/ do |icon, area|
  trip_area_element(area).find("a." + icon.downcase).click
end