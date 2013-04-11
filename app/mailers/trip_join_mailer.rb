class TripJoinMailer < ActionMailer::Base
  default from: "noreply@pohody.com.ua"

  def join_request_user_email(user, trip)
    @user = user
    @trip = trip
    @track = trip.track
    mail(:to => @user.email)
  end

  def join_request_owner_email(user, trip)
    @user = user
    @trip = trip
    @track = trip.track
    mail(:to => trip.user.email)
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

  def decline_email(user, trip)
    @trip = trip
    mail(:to => user.email)
  end
end
