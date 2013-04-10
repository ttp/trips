class TripJoinMailer < ActionMailer::Base
  default from: "noreply@pohody.com.ua"

  def join_request_user_notification_email(user, trip)
    @user = user
    @trip = trip
    mail(:to => @user.email, :subject => "New join request notification")
  end

  def join_request_owner_notification_email(trip)
    @user = trip.user
    @trip = trip
    mail(:to => @user.email, :subject => "New join request notification")
  end

  def leave_email(user, trip)
    @user = user
    @trip = trip

    mail(:to => @trip.user.email)
  end

  def approve_email(user, trip)
    @trip = trip

    mail(:to => user.email)
  end
end
