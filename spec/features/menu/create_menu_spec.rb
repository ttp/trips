require 'rails_helper'

feature 'Create menu', js: true do
  scenario 'Guest creates menu' do
    visit menu_dashboard_path

    click_link 'Create menu'
    fill_in 'name', with: 'Guest menu'
    page.find('button.add-day').click
    click_button 'Save'

    menu = Menu::Menu.find_by(name: 'Guest menu')
    expect(current_path).to eq menu_menu_path(menu)
    expect(page).to have_link('Edit')
  end
end
