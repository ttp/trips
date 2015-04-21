FactoryGirl.define do
  factory :menu_dish_category, class: Menu::DishCategory do
    sequence(:name) { |n| "DishCategory#{n}" }

    trait :with_dishes do
      transient do
        dishes_count 3
      end

      after(:create) do |category, evaluator|
        create_list(:menu_dish, evaluator.dishes_count, dish_category: category)
      end
    end
  end
end
