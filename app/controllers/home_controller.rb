# encoding: UTF-8

class HomeController < ApplicationController
  def index
    @upcoming = Trip.upcoming(10)
    @profile_id = Rails.application.config.example_profile_id
  end

  def about
  end
end
