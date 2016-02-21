class Menu::ProductsController < ApplicationController
  before_action :set_menu_product, only: [:show, :edit, :update, :destroy]
  before_action :set_breadcrumb, only: [:index, :category, :show]

  def index
    add_breadcrumb t('menu.products.products')

    fetch_categories
    fetch_products
    paginate_records
  end

  def category
    fetch_categories
    fetch_products
    @menu_products = @menu_products.by_category(params[:category])
    @category = Menu::ProductCategory.find(params[:category])

    add_breadcrumb t('menu.products.products'), menu_products_path
    add_breadcrumb @category.name
    paginate_records
    render :index
  end

  def show
    authorize @menu_product, :show?

    add_breadcrumb t('menu.products.products'), menu_products_path
    add_breadcrumb @menu_product.product_category.name, by_category_menu_products_path(@menu_product.product_category_id)
    add_breadcrumb @menu_product.name
  end

  def new
    authorize Menu::Product, :create?

    @menu_product = Menu::Product.new
  end

  def create
    authorize Menu::Product, :create?

    @menu_product = Menu::Product.new(menu_product_params)
    @menu_product.user_id = current_user.id

    if @menu_product.save
      redirect_to back(menu_products_path), notice: t('menu.products.was_created')
    else
      render action: 'new'
    end
  end

  def edit
    authorize @menu_product, :update?
  end

  def update
    authorize @menu_product, :update?

    if @menu_product.update(menu_product_params)
      redirect_to back(menu_products_path), notice: t('menu.products.was_updated')
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize @menu_product, :destroy?

    @menu_product.destroy
    redirect_to back(menu_products_path), notice: t('menu.products.was_destroyed')
  end

  private

  def fetch_products
    @menu_products = policy_scope(Menu::Product.all).order_by_name(I18n.locale)
  end

  def paginate_records
    @menu_products = @menu_products.paginate(page: params[:page], per_page: 25)
  end

  def fetch_categories
    @product_categories = Menu::ProductCategory.order_by_name(I18n.locale)
  end

  def set_menu_product
    @menu_product = Menu::Product.find(params[:id])
  end

  def menu_product_params
    params.require(:menu_product).permit(policy(@menu_product || Menu::Product).permitted_attributes)
  end

  def set_breadcrumb
    add_breadcrumb t('menu.title'), menu_dashboard_path
  end
end
