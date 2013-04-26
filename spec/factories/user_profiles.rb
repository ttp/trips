# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_profile do
    about 'About me'
    experience 'My experience'
    contacts 'My contacts'
    private_contacts 'Private contacts'
    private_info 'Private info'
  end
end
