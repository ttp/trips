class Menu::ProductsController < ApplicationController
  before_action :set_menu_product, only: [:show, :edit, :update, :destroy]

  # GET /menu/products
  def index
    @menu_products = Menu::Product.with_translations(I18n.locale)
    if params[:category]
      @menu_products = @menu_products.by_category(params[:category])
      @category = Menu::ProductCategory.find(params[:category])
    end
    @menu_products = @menu_products.order('name').paginate(:page => params[:page], :per_page => 25)
    @product_categories = Menu::ProductCategory.by_lang(I18n.locale).to_hash
  end

  # GET /menu/products/1
  def show
  end

  # GET /menu/products/new
  def new
    @menu_product = Menu::Product.new
  end

  # GET /menu/products/1/edit
  def edit
  end

  # POST /menu/products
  def create
    @menu_product = Menu::Product.new(menu_product_params)

    if @menu_product.save
      redirect_to @menu_product, notice: 'Product was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /menu/products/1
  def update
    if @menu_product.update(menu_product_params)
      redirect_to @menu_product, notice: 'Product was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /menu/products/1
  def destroy
    @menu_product.destroy
    redirect_to menu_products_url, notice: 'Product was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu_product
      @menu_product = Menu::Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def menu_product_params
      params[:menu_product]
    end
end
