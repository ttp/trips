class Menu::DishSerializer < ActiveModel::Serializer
  attributes :id, :name, :dish_category_id
end
