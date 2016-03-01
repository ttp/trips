class Menu::MealSerializer < ActiveModel::Serializer
  attributes :id
  attribute :name do
    object.translation(:name)
  end
end
