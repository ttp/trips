class Menu::Partition < ApplicationRecord
  belongs_to :menu
  has_many :partition_porters
  has_many :porter_products, through: :partition_porters

  def porters_by_entity(entity)
    @entity_porters_info ||= EntityPortersInfo.new(self)
    @entity_porters_info.porters_by_entity(entity)
  end

  def porters_products_total
    @porter_products_total ||= PorterProductsTotal.new(self)
  end
end
