require 'digest/md5'

class AddEmailHashToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :email_hash, :string
    
    User.all.each do |user|
      user.update_email_hash
      user.save
    end
  end
end
