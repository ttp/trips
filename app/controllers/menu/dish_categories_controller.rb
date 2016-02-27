class Menu::DishCategoriesController < ApplicationController
  before_action :set_menu_dish_category, only: [:edit, :update, :destroy]
  before_action :set_breadcrumb, only: [:index]

  def index
    add_breadcrumb t('menu.dish_categories.title')
    @menu_dish_categories = Menu::DishCategory.order_by_name(I18n.locale)
  end

  def new
    authorize Menu::DishCategory

    @menu_dish_category = Menu::DishCategory.new
  end

  def create
    authorize Menu::DishCategory

    @menu_dish_category = Menu::DishCategory.new(menu_dish_category_params)

    if @menu_dish_category.save
      redirect_to back(menu_dish_categories_path)
    else
      render action: 'new'
    end
  end

  def edit
    authorize @menu_dish_category
  end

  def update
    authorize @menu_dish_category

    if @menu_dish_category.update(menu_dish_category_params)
      redirect_to back(menu_dish_categories_path)
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize @menu_dish_category

    @menu_dish_category.destroy
    redirect_to (request.referer || menu_dish_categories_path)
  end

  private

  def set_menu_dish_category
    @menu_dish_category = Menu::DishCategory.find(params[:id])
  end

  def menu_dish_category_params
    params.require(:menu_dish_category).permit(policy(@menu_dish_category || Menu::DishCategory).permitted_attributes)
  end

  def set_breadcrumb
    add_breadcrumb t('menu.title'), menu_dashboard_path
  end
end
