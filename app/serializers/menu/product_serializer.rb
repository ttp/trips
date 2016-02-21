class Menu::ProductSerializer < ActiveModel::Serializer
  attributes :id, :product_category_id, :calories, :proteins, :fats, :carbohydrates, :norm
  attribute :name do
    object.translation(:name)
  end
  attribute :description do
    object.translation(:description)
  end
end
