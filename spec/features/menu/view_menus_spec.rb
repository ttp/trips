require 'rails_helper'

feature 'View menus' do
  scenario 'View menus list' do
    create :menu_with_days, name: 'Menu example one'
    create :menu_with_days, name: 'Menu example two'

    visit examples_menu_menus_path
    expect(page).to have_css('.menu-item', count: 2)
  end

  scenario 'Show menu' do
    menu = create :menu_with_days, name: 'Menu example one'
    visit examples_menu_menus_path

    click_link menu.name

    expect(page).to have_css('.day', count: 3)
    days = 3
    meals = 3 * days
    dishes = 2 * meals
    products = 3 * dishes
    expect(page).to have_css('.entity', count: meals + dishes + products)
    expect(page).to have_css('.summary')
    expect(page).to have_css('.products')
  end
end
