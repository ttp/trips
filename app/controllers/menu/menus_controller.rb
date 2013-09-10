class Menu::MenusController < ApplicationController
  def index
    @menus = Menu::Menu.find_all_by_is_public(true)
  end

  def show
    @menu = Menu::Menu.find(params[:id])
    @days = @menu.menu_days.order('num')
    @product_entities = @menu.entities_by_type(Menu::DayEntity::PRODUCT)
    @total = @menu.total
    @total_products = @menu.total_products
  end

  def new
    @menu = Menu::Menu.new
  end

  def edit
    @menu = Menu::Menu.find(params[:id])
  end

  # POST /menu
  # POST /menu.json
  def create
    data = JSON.parse(params[:data])
    @menu = Menu::Menu.new
    @menu.name = data['menu']['name']
    @menu.users_qty = data['menu']['users_qty']
    @menu.is_public = true
    @menu.save

    # save days
    save_days(data['days'])

    # save entities
    entities = data["entities"].values.group_by {|entity| entity['parent_id'].to_s}
    save_entities(entities, '0')

    respond_to do |format|
      format.html { redirect_to back(menu_menus_url), notice: I18n.t('menu.was_created') }
      format.json { render json: @menu, status: :created, location: @trip }
    end
  end

  # PUT /menu/1
  # PUT /menu/1.json
  def update
    data = JSON.parse(params[:data])
    @menu = Menu::Menu.find(params[:id])
    @menu.name = data['menu']['name']
    @menu.users_qty = data['menu']['users_qty']
    @menu.save

    # update/remove days
    @menu.menu_days.each do |day|
      day.delete unless data['days'].has_key?(day.id.to_s)
    end
    save_days(data['days'])

    # update/remove entities
    @menu.entities.each do |entity|
      entity.delete unless data['entities'].has_key?(entity.id.to_s)
    end
    entities = data["entities"].values.group_by {|entity| entity['parent_id'].to_s}
    save_entities(entities, '0')

    respond_to do |format|
      format.html { redirect_to back(menu_menus_url), notice: I18n.t('menu.was_updated') }
      format.json { head :no_content }
    end
  end

  def products
    data = {}
    data[:product_categories] = Menu::ProductCategory.by_lang(I18n.locale)
    data[:products] = Menu::Product.by_lang(I18n.locale)
    data[:dish_categories] = Menu::DishCategory.by_lang(I18n.locale)
    data[:dishes] = Menu::Dish.by_lang(I18n.locale)
    data[:dish_products] = Menu::DishProduct.all
    data[:meals] = Menu::Meal.by_lang(I18n.locale)
    render :json => data
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    menu = Menu::Menu.find(params[:id])
    menu.destroy

    respond_to do |format|
      format.html { redirect_to request.referer || menu_menus_url }
      format.json { head :no_content }
    end
  end

private
  def save_entities(entities, parent_cid, parent_id = nil)
    return unless entities.has_key?(parent_cid)

    entities[parent_cid].each do |entity_data|
      if entity_data.has_key?('new')
        entity = Menu::DayEntity.new
        entity.parent_id = parent_id
        entity.entity_id = entity_data['entity_id']
        entity.entity_type = entity_data['entity_type']
        entity.day_id = @day_cid_to_id[entity_data['day_id'].to_s]
      else
        entity = Menu::DayEntity.find(entity_data['id'])
      end
      entity.weight = entity_data['weight']
      entity.save
      save_entities(entities, entity_data['id'].to_s, entity.id)
    end
  end

  def save_days(days)
    @day_cid_to_id = {}
    days.each do |day_id, day_data|
      if day_data.has_key?('new')
        day = Menu::Day.new
        day.menu = @menu
      else
        day = Menu::Day.find(day_id)
      end
      day.num = day_data['num']
      day.save
      @day_cid_to_id[day_id] = day.id
    end
  end
end
