# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :track do
    name "Track name"
    description "Track description"
    track "Track"
    url "track site"
    
    region
    user
  end
end
