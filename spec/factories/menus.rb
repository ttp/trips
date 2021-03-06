FactoryGirl.define do
  factory :menu, class: Menu::Menu do
    user

    name 'New menu'
    users_count 5
    is_public true

    factory :menu_with_days do
      days_count 3
      coverage 3

      after(:create) do |menu, _evaluator|
        FactoryGirl.create_list(:day_with_meals, menu.days_count, menu: menu)
      end
    end
  end

  factory :menu_meal, class: Menu::Meal do
    sequence(:name) { |n| "Meal #{n}" }
  end

  factory :menu_day, class: Menu::Day do
    menu
    num 1

    factory :day_with_meals do
      transient do
        meals_count 3
      end

      after(:create) do |day, evaluator|
        FactoryGirl.create_list(:entity_meal_with_dishes, evaluator.meals_count, day: day)
      end
    end
  end

  factory :menu_day_entity, class: Menu::DayEntity do
    weight { Random.rand(50..100) }
    association :day, factory: :menu_day

    factory :menu_day_entity_product do
      entity_type Menu::DayEntity::PRODUCT
      association :entity, factory: :menu_product
    end

    factory :menu_day_entity_dish do
      entity_type Menu::DayEntity::DISH
      association :entity, factory: :menu_dish

      factory :entity_dish_with_products do
        transient do
          products_count 3
        end

        after(:create) do |entity, evaluator|
          FactoryGirl.create_list(:menu_day_entity_product, evaluator.products_count,
                                  parent_id: entity.id, day: entity.day)
        end
      end
    end

    factory :menu_day_entity_meal do
      entity_type Menu::DayEntity::MEAL
      association :entity, factory: :menu_meal

      factory :entity_meal_with_dishes do
        transient do
          dishes_count 2
        end

        after(:create) do |entity, evaluator|
          FactoryGirl.create_list(:entity_dish_with_products, evaluator.dishes_count,
                                  parent_id: entity.id, day: entity.day)
        end
      end
    end
  end
end
