class Menu::Day < ActiveRecord::Base
  attr_accessible :num
  belongs_to :menu
end
