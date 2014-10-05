class Menu::Partition < ActiveRecord::Base
  belongs_to :menu
  has_many :partition_porters
end
