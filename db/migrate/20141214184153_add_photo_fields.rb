class AddPhotoFields < ActiveRecord::Migration[4.2]
  class Menu::Product < ApplicationRecord
    has_attached_file :photo, styles: { thumb: "64x64>"  }, default_url: "/assets/:style/no-image.png"
    validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  end

  class Menu::Dish < ApplicationRecord
    has_attached_file :photo, styles: { thumb: "64x64>"  }, default_url: "/assets/:style/no-image.png"
    validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/
  end

  def self.up
    Menu::Product.reset_column_information
    Menu::Dish.reset_column_information

    add_attachment :menu_products, :photo
    add_attachment :menu_dishes, :photo

    migrate_product_icons
    migrate_dish_icons
  end

  def self.down
    remove_attachment :menu_products, :photo
    remove_attachment :menu_dishes, :photo
  end

  def migrate_product_icons
    Menu::Product.find_each do |product|
      if product.icon.present?
        file = File.open(product_icon_path(product.icon))
        product.photo = file
        file.close
        product.save!
      end
    end
  end

  def migrate_dish_icons
    Menu::Dish.find_each do |dish|
      if dish.icon.present?
        file = File.open(dish_icon_path(dish.icon))
        dish.photo = file
        file.close
        dish.save!
      end
    end
  end

  def product_icon_path(icon)
    media_path("products/#{icon}")
  end

  def dish_icon_path(icon)
    media_path("dishes/#{icon}")
  end

  def media_path(filename)
    Rails.root.join('public', 'media', filename)
  end
end
