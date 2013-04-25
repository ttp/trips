class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.references :user

      t.text :about, :null => false, :default => ''
      t.text :experience, :null => false, :default => ''
      t.text :contacts, :null => false, :default => ''
      t.text :private_contacts, :null => false, :default => ''
      t.text :private_info, :null => false, :default => ''

      t.timestamps
    end

    add_index :user_profiles, :user_id, :unique => true
  end
end
