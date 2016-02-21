class Menu::DishCategorySerializer < ActiveModel::Serializer
  attributes :id
  attribute :name do
    object.translation(:name)
  end
end
