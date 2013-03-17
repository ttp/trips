class Region < ActiveRecord::Base
  attr_accessible :name
  has_many :tracks
end
