require 'rails_helper'

feature 'Calendar filters', js: true do
  background do
    create_list :trip_in_region, 3, region_name: 'Carpathian'
    create_list :trip_in_region, 2, region_name: 'Crimea'
  end

  scenario 'show list of regions' do
    visit calendar_path
    expect(page).to have_css('#filters', text: 'Carpathian')
    expect(page).to have_css('#filters', text: 'Crimea')
  end

  scenario 'filter trips in calendar' do
    visit calendar_path

    find("#filters input[value='Carpathian']").click

    expect(number_of_events).to eq 3
  end

  private

  def number_of_events
    events_cnt = 0
    all('#calendar .events-count').each do |cnt_el|
      events_cnt += cnt_el.text.to_i
    end
    events_cnt
  end
end
