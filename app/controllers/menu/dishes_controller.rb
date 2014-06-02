class Menu::DishesController < ApplicationController
  before_action :set_menu_dish, only: [:show, :edit, :update, :destroy]
  before_action :validate_access, only: [:edit, :update, :destroy]

  # GET /menu/dishes
  def index
    @menu_dishes = Menu::Dish.with_translations(I18n.locale)
    @menu_dishes = @menu_dishes.for_user(current_user) unless permissions_for('Menu').allowed?('moderate')
    @menu_dishes = @menu_dishes.order('name').paginate(:page => params[:page], :per_page => 25)
    @dish_categories = Menu::DishCategory.by_lang(I18n.locale).to_hash
  end

  # GET /menu/dishes/category/1
  def category
    @menu_dishes = Menu::Dish.with_translations(I18n.locale)
    @menu_dishes = @menu_dishes.for_user(current_user) unless permissions_for('Menu').allowed?('moderate')
    @menu_dishes = @menu_dishes.by_category(params[:category])
    @category = Menu::DishCategory.find(params[:category])

    add_breadcrumb t('menu.dishes.dishes'), menu_dishes_path
    add_breadcrumb @category.name
    @menu_dishes = @menu_dishes.order('name').paginate(:page => params[:page], :per_page => 25)
    @dish_categories = Menu::DishCategory.by_lang(I18n.locale).to_hash
    render :index
  end

  # GET /menu/dishes/1
  def show
    add_breadcrumb t('menu.dishes.dishes'), menu_dishes_path
    add_breadcrumb @menu_dish.dish_category.name, by_category_menu_dishes_path(@menu_dish.dish_category_id)
    add_breadcrumb @menu_dish.name

    @dish_products = @menu_dish.products_list(I18n.locale)
  end

  # GET /menu/dishes/new
  def new
    redirect_to menu_dishes_path unless permissions_for('Menu').allowed?('create')

    @menu_dish = Menu::Dish.new
    prepare_products_map
  end

  # POST /menu/dishes
  def create
    redirect_to menu_dishes_path unless permissions_for('Menu').allowed?('create')

    @menu_dish = Menu::Dish.new(menu_dish_params)
    @menu_dish.user_id = current_user.id

    if @menu_dish.save
      save_products
      redirect_to back(menu_dishes_path), notice: t('menu.dishes.was_created')
    else
      prepare_products_map
      render action: 'new'
    end
  end

  # GET /menu/dishes/1/edit
  def edit
    prepare_products_map
  end

  # PATCH/PUT /menu/dishes/1
  def update
    if @menu_dish.update(menu_dish_params)
      save_products
      redirect_to back(menu_dishes_path), notice: t('menu.dishes.was_updated')
    else
      prepare_products_map
      render action: 'edit'
    end
  end

  # DELETE /menu/dishes/1
  def destroy
    @menu_dish.destroy
    redirect_to (request.referer || menu_dishes_path), notice: t('menu.dishes.was_destroyed')
  end

  private

  def set_menu_dish
    @menu_dish = Menu::Dish.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to menu_dishes_path
  end

  def menu_dish_params
    product_params = params[:menu_dish].dup
    product_params = product_params.except(:is_public, :icon) unless permissions_for('Menu').allowed?('moderate')
    product_params
  end

  def validate_access
    redirect_to menu_dishes_path unless permissions_for('Menu').allowed?('edit', @menu_dish)
  end

  def prepare_products_map
    if params.has_key? :products
      @dish_products_map = params[:products]
    else
      @dish_products_map = @menu_dish.dish_products_map
    end
  end

  def save_products
    products = params[:products] || {}
    exists_products = @menu_dish.dish_products.index_by(&:product_id)

    # remove entities
    exists_products.each do |id, product|
      product.destroy unless products.has_key?(id.to_s)
    end

    # update/create
    products.each do |product_id, weight|
      next unless Menu::Product.exists? product_id
      if exists_products.has_key? product_id.to_i
        product = exists_products[product_id.to_i]
      else
        product = Menu::DishProduct.new
        product.product_id = product_id
        product.dish_id = @menu_dish.id
      end
      product.weight = weight
      product.save
    end
  end
end
