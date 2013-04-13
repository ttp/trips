# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip do
    trip_details "Trip details"
    url "trip_site"
    available_places 10
    start_date (Date.today + 1.day)
    end_date (Date.today + 2.days)

    track
    user
  end

  factory :trip_user do
    approved false
    trip
    user
  end
end
