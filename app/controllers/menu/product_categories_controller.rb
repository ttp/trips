class Menu::ProductCategoriesController < ApplicationController
  before_action :set_menu_product_category, only: [:edit, :update, :destroy]
  before_action :set_breadcrumb, only: [:index]

  def index
    add_breadcrumb t('menu.product_categories.title')
    @menu_product_categories = Menu::ProductCategory.order_by_name(I18n.locale)
  end

  def new
    authorize Menu::ProductCategory

    @menu_product_category = Menu::ProductCategory.new
  end

  def create
    authorize Menu::ProductCategory

    @menu_product_category = Menu::ProductCategory.new(menu_product_category_params)

    if @menu_product_category.save
      redirect_to back(menu_product_categories_path)
    else
      render action: 'new'
    end
  end

  def edit
    authorize @menu_product_category
  end

  def update
    authorize @menu_product_category

    if @menu_product_category.update(menu_product_category_params)
      redirect_to back(menu_product_categories_path)
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize @menu_product_category

    @menu_product_category.destroy
    redirect_to (request.referer || menu_product_categories_path)
  end

  private

  def set_menu_product_category
    @menu_product_category = Menu::ProductCategory.find(params[:id])
  end

  def menu_product_category_params
    params.require(:menu_product_category).permit(policy(@menu_product_category || Menu::ProductCategory).permitted_attributes)
  end

  def set_breadcrumb
    add_breadcrumb t('menu.title'), menu_dashboard_path
  end
end
