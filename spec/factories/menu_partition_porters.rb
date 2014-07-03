# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :menu_porter, :class => 'Menu::PartitionPorter' do
    menu_id 1
    user_id 1
    name "MyString"
  end
end
