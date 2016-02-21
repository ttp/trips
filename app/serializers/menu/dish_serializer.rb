class Menu::DishSerializer < ActiveModel::Serializer
  attributes :id, :dish_category_id
  attribute :name do
    object.translation(:name)
  end
  attribute :description do
    object.translation(:description)
  end
end
