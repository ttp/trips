class Menu::Dish < ActiveRecord::Base
  attr_accessible :name, :dish_category_id, :description, :icon, :is_public
  has_many :dish_products, dependent: :destroy
  belongs_to :dish_category
  belongs_to :user

  scope :by_category, ->(id) { where(dish_category_id: id)}
  scope :for_user, ->(user) {
    if user
      where('is_public = 1 or user_id = ?', user.id)
    else
      where(is_public: true)
    end
  }

  validates :name, :dish_category_id, :presence => true

  translates :name, :description

  class Translation
    attr_accessible :locale
  end

  def self.by_lang(lang)
    connection.select_all(
      "SELECT d.id, d.dish_category_id, dt.name FROM menu_dishes d
      JOIN menu_dish_translations dt ON dt.menu_dish_id = d.id
      WHERE dt.locale = #{quote_value(lang)}")
  end

  def products_list(lang)
    Menu::Dish.connection.select_all(
      "SELECT dp.*, pt.name, dp.weight FROM menu_dish_products dp
       JOIN menu_product_translations pt ON pt.menu_product_id = dp.product_id
       WHERE dp.dish_id = #{self.id} and pt.locale = #{Menu::Dish.quote_value(lang)}"
    )
  end

  def dish_products_map
    Hash[dish_products.map {|dish_product| [dish_product.product_id, dish_product.weight] }]
  end
end
