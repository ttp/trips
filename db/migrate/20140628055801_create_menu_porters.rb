class CreateMenuPorters < ActiveRecord::Migration[4.2]
  def change
    create_table :menu_partitions do |t|
      t.references :menu

      t.timestamps
    end

    create_table :menu_partition_porters do |t|
      t.references :partition
      t.integer :user_id
      t.string :name
      t.integer :position

      t.timestamps
    end

    create_table :menu_partition_porter_products do |t|
      t.references :partition_porter
      t.references :day_entity
    end
  end
end
