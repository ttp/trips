class Api::V1::Menu::ProductsController < Api::V1::BaseController
  def index
    render json: policy_scope(Menu::Product.all)
  end

  def categories
    render json: Menu::ProductCategory.all
  end
end
