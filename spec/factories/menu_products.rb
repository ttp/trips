FactoryGirl.define do
  factory :menu_product, class: Menu::Product do
    sequence(:name) { |n| "Product name #{n}" }
    association :product_category, factory: :menu_product_category
    calories { Random.rand(50..500) }
    proteins { Random.rand(10..100) }
    fats { Random.rand(10..100) }
    carbohydrates { Random.rand(10..100) }
    is_public true
  end
end
