# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :menu_partition_porter, class: 'Menu::PartitionPorter' do
    name 'MyString'
    association :partition, factory: :menu_partition
  end
end
