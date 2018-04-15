class AddPriceUrlToTrip < ActiveRecord::Migration[4.2]
  def change
    add_column :trips, :price, :decimal
    add_column :trips, :url, :string
  end
end
