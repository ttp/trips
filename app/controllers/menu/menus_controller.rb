class Menu::MenusController < ApplicationController
  include MenusHelper

  before_filter :authenticate_user!, :only => [:my]
  around_filter :catch_not_found, :only => [:show, :edit, :update, :destroy]

  def index
    @public_cnt = Menu::Menu.where(is_public: true).count
    if current_user
      @my_cnt = Menu::Menu.where(user_id: current_user.id).count
    end
    @dishes_cnt = Menu::Dish.for_user(current_user).count
    @products_cnt = Menu::Product.for_user(current_user).count
  end

  def my
    @title = t('menu.my_menu')
    @menus = Menu::Menu.where(user_id: current_user.id)
    render 'my'
  end

  def examples
    @menus = Menu::Menu.where(is_public: true)
    render 'examples'
  end

  def show
    @menu = Menu::Menu.find(params[:id])

    redirect_to menu_menus_url and return unless menu_can_view?
  end

  def new
    @menu = Menu::Menu.new
    if params[:trip]
      trip = Trip.find_by(id: params[:trip])
      if trip.user_id == current_user.id
        @menu.name = trip.track.name + ' menu'
        users_count = trip.joined_users.count
        @menu.users_count = users_count if users_count > 0
      end
    end
  end

  def edit
    @menu = Menu::Menu.find(params[:id])
    redirect_to menu_menus_url and return unless menu_can_edit?
  end

  # POST /menu
  # POST /menu.json
  def create
    data = JSON.parse(params[:data])
    @menu = Menu::Menu.new
    @menu.user_id = current_user.id if current_user
    set_menu_data(data['menu'])
    @menu.save

    # save days
    save_days(data['days'])

    # save entities
    entities = data["entities"].values.group_by {|entity| entity['parent_id'].to_s}
    save_entities(entities, '0')

    if params[:trip] != '0'
      trip = Trip.find_by(id: params[:trip])
      if trip.user_id == current_user.id
        trip.menu_id = @menu.id
        trip.save
      end
    end

    respond_to do |format|
      format.html {
        if @menu.user_id
          redirect_to back(menu_menus_url), notice: I18n.t('menu.was_created')
        else
          redirect_to guest_owner_menu_path(@menu)
        end
      }
      format.json { render json: @menu, status: :created, location: @trip }
    end
  end

  # PUT /menu/1
  # PUT /menu/1.json
  def update
    @menu = Menu::Menu.find(params[:id])
    redirect_to menu_menus_url and return unless menu_can_edit?

    data = JSON.parse(params[:data])
    set_menu_data(data['menu'])
    @menu.save

    # update/remove days
    @days = @menu.menu_days.index_by(&:id)
    @days.each do |id, day|
      day.delete unless data['days'].has_key?(id.to_s)
    end
    save_days(data['days'])

    # update/remove entities
    @entities = @menu.entities.index_by(&:id)
    @entities.each do |id, entity|
      entity.delete unless data['entities'].has_key?(id.to_s)
    end
    entities = data["entities"].values.group_by {|entity| entity['parent_id'].to_s}
    save_entities(entities, '0')

    respond_to do |format|
      format.html {
        back_url = user_signed_in? ? menu_menus_url : guest_owner_menu_path(@menu)
        redirect_to back(back_url), notice: I18n.t('menu.was_updated')
      }
      format.json { head :no_content }
    end
  end

  def products
    data = {}
    data[:product_categories] = Menu::ProductCategory.by_lang(I18n.locale)
    data[:products] = Menu::Product.list_by_user(current_user, I18n.locale)
    data[:dish_categories] = Menu::DishCategory.by_lang(I18n.locale)
    data[:dishes] = Menu::Dish.list_by_user(current_user, I18n.locale)
    data[:dish_products] = Menu::DishProduct.all
    data[:meals] = Menu::Meal.by_lang(I18n.locale)
    render :json => data
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    menu = Menu::Menu.find(params[:id])
    if menu.user_id != current_user.id
      redirect_to menu_menus_url and return
    end
    menu.destroy

    respond_to do |format|
      format.html { redirect_to request.referer || menu_menus_url }
      format.json { head :no_content }
    end
  end

private
  def set_menu_data(data)
    @menu.name = data['name']
    @menu.users_count = data['users_count']
    @menu.days_count = data['days_count']
    @menu.coverage = data['coverage']
    @menu.is_public = data['is_public']
  end

  def save_entities(entities, parent_cid, parent_id = nil)
    return unless entities.has_key?(parent_cid)

    entities[parent_cid].each do |entity_data|
      if entity_data.has_key?('new')
        entity = Menu::DayEntity.new
        entity.parent_id = parent_id
        entity.entity_id = entity_data['entity_id']
        entity.entity_type = entity_data['entity_type']
        entity.day_id = @day_cid_to_id[entity_data['day_id'].to_s]
      elsif @entities.has_key? entity_data['id']
        entity = @entities[entity_data['id']]
      end

      unless entity.nil?
        entity.weight = entity_data['weight']
        entity.sort_order = entity_data['sort_order']
        entity.save if entity.changed? || entity.new_record?
        save_entities(entities, entity_data['id'].to_s, entity.id)
      end
    end
  end

  def save_days(days)
    @day_cid_to_id = {}
    days.each do |day_id, day_data|
      if day_data.has_key?('new')
        day = Menu::Day.new
        day.menu = @menu
      elsif @days.has_key?(day_id.to_i)
        day = @days[day_id.to_i]
      end

      unless day.nil?
        day.num = day_data['num']
        day.coverage = day_data['coverage']
        day.save if day.changed? || day.new_record?
        @day_cid_to_id[day_id] = day.id
      end
    end
  end

  def catch_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    redirect_to menu_menus_url, :flash => { :error => t('site.not_found') }
  end
end
