FactoryGirl.define do
  factory :menu_dish, class: Menu::Dish do
    sequence(:name) { |n| "Dish name #{n}" }
    association :dish_category, factory: :menu_dish_category
    is_public true
  end
end
