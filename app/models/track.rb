class Track < ApplicationRecord
  belongs_to :region
  belongs_to :user
  has_many :trips

  validates :name, :region_id, presence: true
end
