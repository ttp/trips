class UserProfile < ActiveRecord::Base
  attr_accessible :about, :experience, :equipment, :contacts, :private_contacts, :private_info
  belongs_to :user
end
