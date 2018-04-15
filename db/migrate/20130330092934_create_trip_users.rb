class CreateTripUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :trip_users do |t|
      t.references :trip
      t.references :user
      t.boolean :approved, :default => false
    end
  end
end
