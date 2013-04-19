class CreateTripComments < ActiveRecord::Migration
  def change
    create_table :trip_comments do |t|
      t.references :user
      t.references :trip
      t.text :comment

      t.timestamps
    end
  end
end
