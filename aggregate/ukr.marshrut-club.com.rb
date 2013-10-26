#!/usr/bin/ruby
# encoding: utf-8

require 'rubygems'
require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'cgi'
require 'csv'

$month_map = {
    "січня" => "01",
    "лютого" => "02",
    "березня" => "03",
    "квітня" => "04",
    "травня" => "05",
    "червня" => "06",
    "липня" => "07",
    "серпня" => "08",
    "вересня" => "09",
    "жовтня" => "10",
    "листопада" => "11",
    "грудня" => "12",
}

def get_dates(dates_str)
  year = 2013
  if /\d–\d/ =~ dates_str
    nums, month = dates_str.split(' ')
    nums = nums.split("–")
    start_date = "#{year}-#{$month_map[month.strip]}-#{nums[0].rjust(2, '0')}"
    end_date = "#{year}-#{$month_map[month.strip]}-#{nums[1].rjust(2, '0')}"
  else
    dates = dates_str.split(' – ')
    day1, month1 = dates[0].split(' ')
    day2, month2 = dates[1].split(' ')

    start_date = "#{year}-#{$month_map[month1]}-#{day1.rjust(2, '0')}"
    end_date = "#{year}-#{$month_map[month2]}-#{day2.rjust(2, '0')}"
  end
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
  track_node = doc.css("div.content b").select { |el| el.inner_text =~ /маршрут/i }.first.parent
  track_node.css("b, br").remove
  track_node.inner_text.strip
end

$domain = 'ukr.marshrut-club.com'
page_path = '/'
http = Net::HTTP.new($domain)
resp = http.get(page_path)
doc = Nokogiri::HTML(resp.body)

title = "Розклад походів"
title_node = doc.css("div.column h3").select {|node| node.inner_text == title}.first


list_node = title_node.next_element

puts ["name", "start_date", "end_date", "region", "track", "url", "has_guide", "available_places"].to_csv
while true do
  if list_node['class'] == 'main_cal_title_r'
    region = list_node.at_css("a").inner_text
  elsif list_node['class'] == 'main_cal_elem_r'
    dates_text = list_node.inner_text.strip
    link_node = list_node.at_css('a')
    start_date, end_date = get_dates(dates_text)
    url = "http://" + $domain + link_node.attr("href")
    puts [
      link_node.inner_text.strip,
      start_date,
      end_date,
      get_region_name(region),
      get_track(url),
      url,
      "yes",
      10
    ].to_csv
  else
    break
  end
  list_node = list_node.next_element
end