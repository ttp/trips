class Menu::ProductsController < ApplicationController
  before_action :set_menu_product, only: [:show, :edit, :update, :destroy]
  before_action :validate_access, only: [:edit, :update, :destroy]

  # GET /menu/products
  def index
    @menu_products = Menu::Product.with_translations(I18n.locale)
    @menu_products = @menu_products.for_user(current_user) unless permissions_for('Menu').allowed?('moderate')
    @menu_products = @menu_products.order('name').paginate(:page => params[:page], :per_page => 25)
    @product_categories = Menu::ProductCategory.by_lang(I18n.locale).to_hash
  end

  # GET /menu/products/category/1
  def category
    @menu_products = Menu::Product.with_translations(I18n.locale)
    @menu_products = @menu_products.for_user(current_user) unless permissions_for('Menu').allowed?('moderate')
    @menu_products = @menu_products.by_category(params[:category])
    @category = Menu::ProductCategory.find(params[:category])

    add_breadcrumb t('menu.products.products'), menu_products_path
    add_breadcrumb @category.name
    @menu_products = @menu_products.order('name').paginate(:page => params[:page], :per_page => 25)
    @product_categories = Menu::ProductCategory.by_lang(I18n.locale).to_hash
    render :index
  end

  # GET /menu/products/1
  def show
    add_breadcrumb t('menu.products.products'), menu_products_path
    add_breadcrumb @menu_product.product_category.name, by_category_menu_products_path(@menu_product.product_category_id)
    add_breadcrumb @menu_product.name
  end

  # GET /menu/products/new
  def new
    redirect_to menu_products_path unless permissions_for('Menu').allowed?('create')

    @menu_product = Menu::Product.new
  end

  # POST /menu/products
  def create
    redirect_to menu_products_path unless permissions_for('Menu').allowed?('create')

    @menu_product = Menu::Product.new(menu_product_params)
    @menu_product.user_id = current_user.id

    if @menu_product.save
      redirect_to back(menu_products_path), notice: t('menu.products.was_created')
    else
      render action: 'new'
    end
  end

  # GET /menu/products/1/edit
  def edit
  end

  # PATCH/PUT /menu/products/1
  def update
    if @menu_product.update(menu_product_params)
      redirect_to back(menu_products_path), notice: t('menu.products.was_updated')
    else
      render action: 'edit'
    end
  end

  # DELETE /menu/products/1
  def destroy
    @menu_product.destroy
    redirect_to (request.referer || menu_menus_url), notice: t('menu.products.was_destroyed')
  end

  private

  def set_menu_product
    @menu_product = Menu::Product.find(params[:id])
  end

  def menu_product_params
    product_params = params[:menu_product].dup
    product_params = product_params.except(:is_public, :icon) unless permissions_for('Menu').allowed?('moderate')
    product_params
  end

  def validate_access
    redirect_to menu_products_path unless permissions_for('Menu').allowed?('edit', @menu_product)
  end
end
