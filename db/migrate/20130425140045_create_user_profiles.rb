class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user

      t.text :about
      t.text :experience
      t.text :equipment
      t.text :contacts
      t.text :private_contacts
      t.text :private_info

      t.timestamps
    end

    add_index :user_profiles, :user_id, :unique => true
  end
end
