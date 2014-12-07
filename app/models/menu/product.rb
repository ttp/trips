class Menu::Product < ActiveRecord::Base
  attr_accessible :name, :calories, :proteins, :fats, :carbohydrates, :product_category_id, :icon,
                  :description, :norm_info, :norm, :is_public
  belongs_to :product_category
  belongs_to :user

  scope :by_category, ->(id) { where(product_category_id: id)}
  scope :for_user, ->(user) {
    where('is_public = ? or user_id = ?', true, user.id)
  }
  scope :is_public, -> { where(is_public: true) }

  validates :name, :product_category_id, :calories, :proteins, :fats, :carbohydrates, :presence => true

  translates :name, :description, :norm_info
  class Translation
    attr_accessible :locale
  end

  def self.list_by_user(user, lang)
    sql = "SELECT p.*, pt.name FROM menu_products p
      JOIN menu_product_translations pt ON pt.menu_product_id = p.id
      WHERE pt.locale = #{connection.quote(lang)}"
    if user
      sql += " and (p.is_public = #{connection.quote(true)} or p.user_id = #{user.id})"
    else
      sql += " and p.is_public = #{connection.quote(true)}"
    end
    connection.select_all(sql)
  end
end
