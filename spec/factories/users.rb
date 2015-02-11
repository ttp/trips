# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "user#{n}" }
    sequence(:email) {|n| "user#{n}@factory.com" }
    password 'password'
    password_confirmation 'password'
    role 'user'

    trait :admin do
      role 'admin'
    end

    trait :user do
      role 'user'
    end
  end
end
