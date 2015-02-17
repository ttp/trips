# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :trip do
    trip_details 'Trip details'
    url 'trip_site'
    available_places 10
    start_date Date.today + 1.day
    end_date Date.today + 2.days

    track
    user

    factory :trip_in_region do
      transient do
        region_name 'Region'
      end

      before(:create) do |trip, evaluator|
        region = Region.find_by_name(evaluator.region_name)
        region = create(:region, name: evaluator.region_name) unless region
        trip.track = create :track, region: region
      end
    end
  end

  factory :trip_user do
    approved false
    trip
    user
  end
end
