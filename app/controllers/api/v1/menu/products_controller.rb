class Api::V1::Menu::ProductsController < Api::V1::BaseController
  def index
    products = policy_scope(Menu::Product).preload(:translations)
    render json: products
  end

  def categories
    render json: Menu::ProductCategory.preload(:translations)
  end
end
