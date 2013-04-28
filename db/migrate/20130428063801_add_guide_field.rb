class AddGuideField < ActiveRecord::Migration
  def change
  	add_column :trips, :has_guide, :boolean, :null => false, :default => false
  	remove_column :trips, :price
  end
end
