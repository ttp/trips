#!/usr/bin/ruby
# encoding: utf-8

require 'rubygems'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'cgi'
require 'csv'

$month_map = {
  'січня' => '01',
  'лютого' => '02',
  'березня' => '03',
  'квітня' => '04',
  'травня' => '05',
  'червня' => '06',
  'липня' => '07',
  'серпня' => '08',
  'вересня' => '09',
  'жовтня' => '10',
  'листопада' => '11',
  'грудня' => '12'
}

def get_dates(dates_str)
  year = 2014
  dates = dates_str.scan(/\d{2}/)
  start_date = "#{year}-#{dates[1]}-#{dates[0]}"
  end_date = "#{year}-#{dates[3]}-#{dates[2]}"
  [start_date, end_date]
end

def get_region_name(region)
  case region
    when /кр[иы]{1}м/i then 'Crimea'
    when /карпат/i then 'Carpathian'
    when /непал/i then 'Nepal'
    when /кавказ/i then 'Caucasus'
    when /абхаз/i then 'Caucasus'
    when /грузи/i then 'Caucasus'
    when /румун/i then 'Romania'
    when /турц/i then 'Turkey'
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

site_root = 'http://ho4uvpohod.com'

content = ''
open(site_root) do |f|
  content = f.read
end
doc = Nokogiri::HTML(content)

puts %w(name start_date end_date region track url has_guide available_places).to_csv

schedule = doc.at_css('#route_schedule')
schedule.css('.route_schedule_block').each do |schedule_item|
  link_node = schedule_item.at_css('a')
  region = get_region_name(link_node.attr('title'))
  dates_text = schedule_item.at_css('.route_schedule_dates').inner_text
  start_date, end_date = get_dates(dates_text)
  url = site_root + '/' + link_node.attr('href')
  puts [
    link_node.inner_text.strip,
    start_date,
    end_date,
    region,
    get_track(url),
    url,
    'yes',
    10
  ].to_csv
end
