class Menu::PartitionPorter < ActiveRecord::Base
  belongs_to :partition
  has_many :porter_products, class_name: 'Menu::PartitionPorterProduct'
  has_many :day_entities, through: :porter_products
end
