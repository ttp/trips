class AddIndexesToMenuPartitions < ActiveRecord::Migration[4.2]
  def change
    add_index :menu_partitions, :menu_id
    add_index :menu_partition_porters, :partition_id
    add_index :menu_partition_porter_products, :partition_porter_id
  end
end
