#!/usr/bin/ruby
# encoding: utf-8

require 'rubygems'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'cgi'
require 'csv'

def get_dates(dates_str)
  dates_str = dates_str.gsub(' ', '')
  regexp = /^\d{2}\.\d{2}\.\d{4}\-\d{2}\.\d{2}\.\d{4}$/
  return unless dates_str =~ regexp

  date1, date2 = dates_str.split('-')

  day1, month1, year1 = date1.split('.')
  day2, month2, year2 = date2.split('.')

  start_date = "#{year1}-#{month1}-#{day1}"
  end_date = "#{year2}-#{month2}-#{day2}"
  [start_date, end_date]
end

def get_region_name(region)
  case region
    when /кр[иы]{1}м/i then 'Crimea'
    when /карпат[иы]{1}/i then 'Carpathian'
    when /непал/i then 'Nepal'
    when /кавказ/i then 'Caucasus'
    when /румун/i then 'Romania'
    else 'Other'
  end
end

def get_track(url)
  content = ''
  open(url) do |f|
    content = f.read
  end
  doc = Nokogiri::HTML(content)
  track_node_head = doc.css('table.route td').select { |el| el.inner_text =~ /Нитка маршрута/i }.first
  track_node = track_node_head.next_element
  track_node.inner_text.strip
end

calendar_page = 'http://tracking.org.ua/timetable.html'
calendar_page = 'http://tracking.org.ua/timetable_p2.html'

content = ''
open(calendar_page) do |f|
  content = f.read
end
doc = Nokogiri::HTML(content)

table_rows = doc.css('#table tr')
region = nil
name = nil
dates = nil
url = nil

puts %w(name start_date end_date region track url has_guide available_places).to_csv
table_rows.each_with_index do |row, i|
  next if i == 0
  cells = row.css('td')
  if cells.size == 1
    region_h1 = row.at_css('h1[align="center"]') || row.at_css('div[align="center"] h1')
    if region_h1
      region = region_h1.inner_text.strip
    end
  elsif cells.size == 2 # additional dates for prev trip
    dates = get_dates(cells[0].inner_text.strip)
    next if dates.nil? || region.nil?

    puts [
      name,
      dates[0],
      dates[1],
      get_region_name(region),
      '',
      url,
      'yes',
      10
    ].to_csv
  else # trip row
    dates = get_dates(cells[0].inner_text.strip)
    link_node = row.css('a').select { |el| !el.inner_text.strip.empty? }.first
    name = link_node.inner_text.strip
    url = link_node.attr('href')

    next if dates.nil? || region.nil?

    puts [
      name,
      dates[0],
      dates[1],
      get_region_name(region),
      '',
      url,
      'yes',
      10
    ].to_csv
  end
end
