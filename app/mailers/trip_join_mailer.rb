class TripJoinMailer < ActionMailer::Base
  default from: "noreply@pohody.com.ua"

  def join_request_user_email(user, trip)
    @user = user
    @trip = trip
    @track = trip.track
    I18n.with_locale(I18n.locale) do
      mail(:to => @user.email)
    end
  end

  def join_request_owner_email(user, trip)
    @user = user
    @trip = trip
    @track = trip.track
    I18n.with_locale(I18n.locale) do
      mail(:to => trip.user.email)
    end
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
