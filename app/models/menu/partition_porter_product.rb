class Menu::PartitionPorterProduct < ActiveRecord::Base
  belongs_to :partition_porter, class_name: 'Menu::PartitionPorter'
  belongs_to :day_entity
end
