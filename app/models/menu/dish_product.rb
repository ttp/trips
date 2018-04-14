class Menu::DishProduct < ApplicationRecord
  belongs_to :dish
  belongs_to :product

  scope :for_user, lambda { |user|
    joins(:product).where('menu_products.is_public = ? or menu_products.user_id = ?', true, user.id)
  }
  scope :is_public, -> { joins(:product).where('menu_products.is_public = ?', true) }
end
