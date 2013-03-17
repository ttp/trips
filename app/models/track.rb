class Track < ActiveRecord::Base
  attr_accessible :name, :region_id, :description, :track, :details_url
  belongs_to :region
  belongs_to :user
  has_many :trips

  validates :name, :region_id, :presence => true
end
