class Menu::PartitionPorterProduct < ApplicationRecord
  belongs_to :partition_porter, class_name: 'Menu::PartitionPorter', optional: true
  belongs_to :day_entity, optional: true
end
