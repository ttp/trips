class Track < ActiveRecord::Base
  belongs_to :region
  belongs_to :user
  has_many :trips

  validates :name, :region_id, presence: true
end
