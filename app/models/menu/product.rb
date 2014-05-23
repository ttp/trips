class Menu::Product < ActiveRecord::Base
  attr_accessible :name, :calories, :proteins, :fats, :carbohydrates, :product_category_id, :icon,
                  :description, :norm_info, :norm, :is_public
  belongs_to :product_category
  belongs_to :user

  scope :by_category, ->(id) { where(product_category_id: id)}
  scope :for_user, -> (user) {
    if user
      where('is_public = 1 or user_id = ?', user.id)
    else
      where(is_public: true)
    end
  }

  validates :name, :product_category_id, :calories, :proteins, :fats, :carbohydrates, :presence => true

  translates :name, :description, :norm_info
  class Translation
    attr_accessible :locale
  end

  def self.list_by_user(user, lang)
    sql = "SELECT p.*, pt.name FROM menu_products p
      JOIN menu_product_translations pt ON pt.menu_product_id = p.id
      WHERE pt.locale = #{quote_value(lang)}"
    if user
      sql += " and (p.is_public = 1 or p.user_id = #{user.id})"
    else
      sql += " and p.is_public = 1"
    end
    connection.select_all(sql)
  end
end
