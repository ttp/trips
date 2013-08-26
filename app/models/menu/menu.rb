class Menu::Menu < ActiveRecord::Base
  attr_accessible :name, :users_qty, :is_public
  belongs_to :user
  has_many :menu_days, :class_name => 'Menu::Day'
end