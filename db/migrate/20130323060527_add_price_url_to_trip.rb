class AddPriceUrlToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :price, :decimal
    add_column :trips, :url, :string
  end
end
