# encoding: UTF-8

class HomeController < ApplicationController
  def index
    @abbr_day_names = %w(нд. пн. вт. ср. чт. пт. сб.)
    @first_day = 1
  end
end
