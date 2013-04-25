class UserProfile < ActiveRecord::Base
  attr_accessible :about, :experience, :contacts, :private_contacts, :private_info
  belongs_to :user
end
