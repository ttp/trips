require 'digest'

class Api::V1::Menu::DishesController < Api::V1::BaseController
  def index
    dishes = policy_scope(Menu::Dish.all)
    render json: dishes
  end

  def categories
    render json: Menu::DishCategory.all
  end

  def all_dish_products
    render json: policy_scope(Menu::DishProduct.all)
  end
end
