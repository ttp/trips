#!/usr/bin/ruby
# encoding: utf-8

require 'rubygems'
require 'net/http'
require 'hpricot'
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

domain = 'ukr.marshrut-club.com'
page_path = '/'
http = Net::HTTP.new(domain)
resp = http.get(page_path)
doc = Hpricot(resp.body)

title = "Розклад походів"
title_node = doc.search("div.column h3").select {|node| node.inner_text == title}.first


list_node = title_node.next_sibling

puts ["name", "start_date", "end_date", "region", "url"].to_csv
while true do
  break if list_node.name != "p"

  region = list_node.search("b").first.inner_text
  list_node.search("br").each do |br_node|
    break if br_node.next_sibling.nil?

    dates_text = br_node.next_node.inner_text.strip
    link_node = br_node.next_sibling
    start_date, end_date = get_dates(dates_text)
    puts [
      link_node.inner_text.strip,
      start_date,
      end_date,
      region,
      link_node.get_attribute("href")
    ].to_csv
  end
  list_node = list_node.next_sibling
end