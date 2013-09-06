class MenusController < ApplicationController
  def index
    @menus = Menu::Menu.find_all_by_is_public(true)
  end

  def show
    @menu = Menu::Menu.find(params[:id])
    @days = @menu.menu_days.order('num')
    @product_entities = @menu.entities_by_type(Menu::DayEntity::PRODUCT)
    @total = @menu.total
    @total_products = @menu.total_products
  end

  def new
    @menu = Menu::Menu.new
  end

  def edit

  end

  # POST /menu
  # POST /menu.json
  def create
    @menu = Menu::Menu.new(params[:menu])
    @menu.is_public = true
  end

  # PUT /menu/1
  # PUT /menu/1.json
  def update
    @menu = Menu::Menu.find(params[:id])
    #redirect_to menu_url and return if @menu.user_id != current_user.id
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
