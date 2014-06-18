class NotificationsMailer < ActionMailer::Base
  default from: "noreply@pohody.com.ua"
  add_template_helper MenusHelper

  def new_menu_added_email(menu)
    @menu = menu
    mail(:to => Rails.application.config.site[:notification_email])
  end

  def new_trip_added_email(trip)
    @trip = trip
    mail(:to => Rails.application.config.site[:notification_email])
  end
end