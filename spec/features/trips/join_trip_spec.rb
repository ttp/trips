require 'rails_helper'

feature 'Join trip', js: true do
  given!(:trip) { create :trip_in_region, region_name: 'Carpathian'  }
  given(:user) { create :user }

  background do
    reset_mailer
  end

  scenario 'I see login link' do
    visit trip_path(trip)

    expect(trip_users_section).to  have_link('Login')
  end

  scenario 'Join button adds user to Want to join list' do
    sign_in user
    visit trip_path(trip)
    click_button 'Join'

    expect(pending_users_section).to have_text user.name
    expect(pending_users_section).to have_css 'a.leave'
    expect(emails_count(user.email, 'New join request')).to eq 1
    expect(emails_count(trip.user.email, 'New join request')).to eq 1
  end

  scenario 'Leave button removes user from users section' do
    sign_in user
    visit trip_path(trip)
    click_button 'Join'
    find('a.leave').click

    expect(pending_users_section).not_to have_text  user.name
    expect(emails_count(trip.user.email, 'User has left trip')).to eq 1
  end

  scenario 'Trip owner is able to approve join request' do
    pending_user = create(:user)
    create :trip_user, trip: trip, user: pending_user

    sign_in trip.user
    visit trip_path(trip)
    find('a.approve').click

    expect(pending_users_section).not_to have_text pending_user.name
    expect(joined_users_section).to have_text pending_user.name
    expect(emails_count(pending_user.email, 'Your join request has been approved')).to eq 1
  end

  scenario 'Trip owner is able to decline join request' do
    pending_user = create(:user)
    create :trip_user, trip: trip, user: pending_user

    sign_in trip.user
    visit trip_path(trip)

    within pending_users_section do
      find('a.decline').click
    end
    find("#decline_reason .btn-primary").click

    expect(pending_users_section).not_to have_text pending_user.name
    expect(emails_count(pending_user.email, 'Your join request has been declined')).to eq 1
  end

  private

  def trip_users_section
    find("#trip_users")
  end

  def joined_users_section
    find("#trip_users .trip-users")
  end

  def pending_users_section
    find("#trip_users .want-to-join-users")
  end

  def comments_section
    find("#trip_comments")
  end

  def emails_count(address, subject)
    unread_emails_for(address).select { |m| m.subject =~ Regexp.new(Regexp.escape(subject)) }.size
  end
end
