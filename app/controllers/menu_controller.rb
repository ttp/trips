class MenuController < ApplicationController
  def index
    @menus = Menu::Menu.find_all_by_is_public(true)
  end

  def show
    @menu = Menu::Menu.find(params[:id])
  end

  def new

  end

  def edit

  end

  def products
    data = {}
    data[:product_categories] = Menu::ProductCategory.by_lang(I18n.locale)
    data[:products] = Menu::Product.by_lang(I18n.locale)
    data[:dish_categories] = Menu::DishCategory.by_lang(I18n.locale)
    data[:dishes] = Menu::Dish.by_lang(I18n.locale)
    data[:dish_products] = Menu::DishProduct.all
    data[:meals] = Menu::Meal.by_lang(I18n.locale)
    render :json => data
  end
end
