FactoryGirl.define do
  factory :menu_product_category, class: Menu::ProductCategory do
    sequence(:name) { |n| "Category name #{n}" }

    trait :with_products do
      transient do
        products_count 3
      end

      after(:create) do |category, evaluator|
        create_list(:menu_product, evaluator.products_count, product_category: category)
      end
    end
  end
end
