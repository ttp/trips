class Menu::MealsController < ApplicationController
  before_action :set_menu_meal, only: [:edit, :update, :destroy]
  before_action :set_breadcrumb, only: [:index]

  def index
    add_breadcrumb t('menu.meals.meals')
    @menu_meals = Menu::Meal.order_by_name(I18n.locale)
  end

  def new
    authorize Menu::Meal

    @menu_meal = Menu::Meal.new
  end

  def create
    authorize Menu::Meal

    @menu_meal = Menu::Meal.new(menu_meal_params)

    if @menu_meal.save
      redirect_to back(menu_meals_path)
    else
      render action: 'new'
    end
  end

  def edit
    authorize @menu_meal
  end

  def update
    authorize @menu_meal

    if @menu_meal.update(menu_meal_params)
      redirect_to back(menu_meals_path)
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize @menu_meal

    @menu_meal.destroy
    redirect_to (request.referer || menu_meals_path)
  end

  private

  def set_menu_meal
    @menu_meal = Menu::Meal.find(params[:id])
  end

  def menu_meal_params
    params.require(:menu_meal).permit(policy(@menu_meal || Menu::Meal).permitted_attributes)
  end

  def set_breadcrumb
    add_breadcrumb t('menu.title'), menu_dashboard_path
  end
end
