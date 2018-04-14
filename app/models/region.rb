class Region < ApplicationRecord
  # attr_accessible :name
  has_many :tracks

  def t
    I18n.t(name, scope: 'region')
  end

  def self.sorted
    all.sort do |x, y|
      x.t <=> y.t
    end
  end
end
