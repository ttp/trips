class Menu::Meal < ActiveRecord::Base
  include ::Translatable

  multilang :name
end
