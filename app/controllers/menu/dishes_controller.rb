class Menu::DishesController < ApplicationController
  before_action :set_breadcrumb, only: [:index, :category, :show]
  before_action :set_menu_dish, only: [:show, :edit, :update, :destroy]

  def index
    add_breadcrumb t('menu.dishes.dishes')

    fetch_categories
    fetch_dishes
    paginate_records
  end

  def category
    fetch_categories
    fetch_dishes
    @menu_dishes = @menu_dishes.by_category(params[:category])
    @category = Menu::DishCategory.find(params[:category])

    add_breadcrumb t('menu.dishes.dishes'), menu_dishes_path
    add_breadcrumb @category.name
    paginate_records
    render :index
  end

  def show
    authorize @menu_dish, :show?

    add_breadcrumb t('menu.dishes.dishes'), menu_dishes_path
    add_breadcrumb @menu_dish.dish_category.name, by_category_menu_dishes_path(@menu_dish.dish_category_id)
    add_breadcrumb @menu_dish.name
    @menu_dish.dish_products.preload(:products)
  end

  def new
    authorize Menu::Dish, :create?

    @menu_dish = Menu::Dish.new
    prepare_dish_products
  end

  def create
    authorize Menu::Dish, :create?

    @menu_dish = Menu::Dish.new(menu_dish_params)
    @menu_dish.user_id = current_user.id

    if @menu_dish.save
      save_products
      redirect_to back(menu_dishes_path), notice: t('menu.dishes.was_created')
    else
      prepare_dish_products
      render action: 'new'
    end
  end

  def edit
    authorize @menu_dish, :update?

    prepare_dish_products
  end

  def update
    authorize @menu_dish, :update?

    if @menu_dish.update(menu_dish_params)
      save_products
      redirect_to back(menu_dishes_path), notice: t('menu.dishes.was_updated')
    else
      prepare_dish_products
      render action: 'edit'
    end
  end

  def destroy
    authorize @menu_dish, :destroy?

    @menu_dish.destroy
    redirect_to (request.referer || menu_dishes_path), notice: t('menu.dishes.was_destroyed')
  end

  private

  def fetch_dishes
    @menu_dishes = policy_scope(Menu::Dish.all).order_by_name(I18n.locale)
  end

  def paginate_records
    @menu_dishes = @menu_dishes.paginate(page: params[:page], per_page: 25)
  end

  def fetch_categories
    @dish_categories = Menu::DishCategory.order_by_name(I18n.locale)
  end

  def set_menu_dish
    @menu_dish = Menu::Dish.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to menu_dishes_path
  end

  def menu_dish_params
    params.require(:menu_dish).permit(policy(@menu_dish || Menu::Dish).permitted_attributes)
  end

  def prepare_dish_products
    if params.key? :products
      @dish_products = params[:products].map { |key, value| { product_id: key, weight: value } }
    else
      @dish_products = @menu_dish.dish_products
    end
  end

  def save_products
    products = params[:products] || {}
    exists_products = @menu_dish.dish_products.index_by(&:product_id)

    # remove entities
    exists_products.each do |id, product|
      product.destroy unless products.key?(id.to_s)
    end

    # update/create
    sort_order = 0
    products.each do |product_id, weight|
      next unless Menu::Product.exists? product_id
      if exists_products.key? product_id.to_i
        product = exists_products[product_id.to_i]
      else
        product = Menu::DishProduct.new
        product.product_id = product_id
        product.dish_id = @menu_dish.id
      end
      product.weight = weight
      product.sort_order = sort_order
      product.save
      sort_order += 1
    end
    @menu_dish.make_products_public
  end

  def set_breadcrumb
    add_breadcrumb t('menu.title'), menu_dashboard_path
  end
end
