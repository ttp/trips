class FoodController < ApplicationController
  def index
  end

  def products
    data = {}
    data[:product_categories] = Menu::ProductCategory.by_lang(I18n.locale)
    data[:products] = Menu::Product.by_lang(I18n.locale)
    render :json => data
  end
end
