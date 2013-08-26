FactoryGirl.define do
  factory :menu, :class => Menu::Menu do
    user

    name "New menu"
    users_qty 5
    is_public false
  end

  factory :menu_day do
    menu
    num 1
  end
end