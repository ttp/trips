# encoding: UTF-8

class HomeController < ApplicationController
  def index
    @upcoming = Trip.upcoming(10)
  end

  def about
  end
end
