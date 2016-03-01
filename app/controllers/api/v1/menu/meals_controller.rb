class Api::V1::Menu::MealsController < Api::V1::BaseController
  def index
    meals = Menu::Meal.all
    render json: meals
  end
end
