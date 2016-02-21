class Menu::Dish < ActiveRecord::Base
  has_many :dish_products, -> { order 'sort_order' }, dependent: :destroy
  has_many :products, :class_name => 'Menu::Product', through: :dish_products
  belongs_to :dish_category
  belongs_to :user

  has_attached_file :photo, styles: { thumb: '64x64>'  }, default_url: ':style/no-image.png'
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  validates :name, :dish_category_id, presence: true

  scope :by_category, ->(id) { where(dish_category_id: id) }
  scope :for_user, lambda { |user|
    if user
      where('is_public = ? or user_id = ?', true, user.id)
    else
      where(is_public: true)
    end
  }
  scope :is_public, -> { where(is_public: true) }
  scope :is_private, -> { where(is_public: false) }

  translates :name, :description

  def self.by_lang(lang)
    connection.select_all(
      "SELECT d.id, d.dish_category_id, dt.name FROM menu_dishes d
      JOIN menu_dish_translations dt ON dt.menu_dish_id = d.id
      WHERE dt.locale = #{connection.quote(lang)}")
  end

  def products_list(lang)
    Menu::Dish.connection.select_all(
      "SELECT dp.*, pt.name, dp.weight FROM menu_dish_products dp
       JOIN menu_product_translations pt ON pt.menu_product_id = dp.product_id
       WHERE dp.dish_id = #{id} and pt.locale = #{self.class.connection.quote(lang)}
       ORDER BY dp.sort_order"
    )
  end

  def make_products_public
    if persisted? && is_public?
      products.is_private.update_all is_public: true
    end
  end
end
