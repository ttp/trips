require 'rails_helper'

feature 'Trips list', js: true do

  background do
    create_list :trip_in_region, 3, region_name: 'Carpathian'
    create_list :trip_in_region, 2, region_name: 'Crimea'
  end


  scenario 'Show trips list' do
    visit calendar_path
    expect(page).to have_selector("td.start-day .day-wrapper")

    find('td.start-day').click

    expect(page).to have_css("#trips .trip", count: 5)
  end

  scenario 'Close trips list' do
    visit calendar_path
    expect(page).to have_selector("td.start-day .day-wrapper")

    find('td.start-day').click
    find("#trips button.close").click

    expect(page).to have_css("#filters", visible: true)
  end
end
