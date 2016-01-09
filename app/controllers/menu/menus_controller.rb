class Menu::MenusController < ApplicationController
  include MenusHelper

  before_action :authenticate_user!, only: [:my]
  around_action :catch_not_found, only: [:show, :edit, :update, :destroy]

  def index
    @public_cnt = Menu::Menu.where(is_public: true).count
    @my_cnt = Menu::Menu.where(user_id: current_user.id).count if current_user
    @dishes_cnt = Menu::Dish.for_user(current_user).count
    @products_cnt = policy_scope(Menu::Product).count
  end

  def dashboard
    redirect_to menu_dashboard_path
  end

  def all
    authorize Menu::Menu, :view_all?

    @menus = Menu::Menu.preload(:user).order('id desc').paginate(page: params[:page], per_page: 10)
    render 'all'
  end

  def my
    add_breadcrumb t('menu.title'), menu_dashboard_path
    add_breadcrumb t('menu.my_menu')

    @title = t('menu.my_menu')
    @menus = policy_scope(Menu::Menu)
    render 'my'
  end

  def examples
    add_breadcrumb t('menu.title'), menu_dashboard_path
    add_breadcrumb t('menu.examples')

    @menus = Menu::Menu.where(is_public: true)
    render 'examples'
  end

  def show
    @menu = Menu::Menu.find(params[:id])
    raise NotAuthorizedError.new unless policy(@menu).show?(params[:key])
    set_show_breadcrumbs
    @menu.users_count = users_count_param if params[:users_count].present?
  end

  def users_count_param
    users_count = params[:users_count].to_i
    users_count = 1 unless (1..100).include? users_count
    users_count
  end

  def new
    @menu = Menu::Menu.new
    init_menu_for_trip if params[:trip]
    init_from_clone if params.key?(:create_from)
  end

  def init_menu_for_trip
    trip = Trip.find_by(id: params[:trip])
    authorize trip, :edit?
    @menu.name = trip.track.name + ' menu'
    users_count = trip.joined_users.count
    @menu.users_count = users_count if users_count > 0
  end

  def init_from_clone
    menu_clone = Menu::Menu.find(params[:create_from])
    raise NotAuthorizedError.new unless policy(menu_clone).show?(params[:key])
    @menu.menu_days = menu_clone.menu_days
    @menu.entities = menu_clone.entities
  end

  def edit
    @menu = Menu::Menu.find(params[:id])
    raise NotAuthorizedError.new unless policy(@menu).edit?(params[:key])
  end

  def create
    data = JSON.parse(params[:data])
    @menu = Menu::Menu.new
    @menu.user_id = current_user.id if current_user
    set_menu_data(data['menu'])
    @menu.save

    # save days
    save_days(data['days'])

    # save entities
    entities = data['entities'].values.group_by { |entity| entity['parent_id'].to_s }
    save_entities(entities, '0')

    set_trip_menu

    NotificationsMailer.new_menu_added_email(@menu).deliver_now

    if @menu.user_id
      redirect_to back(menu_menus_url), notice: I18n.t('menu.was_created')
    else
      redirect_to guest_owner_menu_path(@menu)
    end
  end

  def set_trip_menu
    if params[:trip] != '0'
      trip = Trip.find_by(id: params[:trip])
      if trip.user_id == current_user.id
        trip.menu_id = @menu.id
        trip.save
      end
    end
  end

  def update
    @menu = Menu::Menu.find(params[:id])
    @menu.touch
    redirect_to(menu_menus_url) && return unless menu_can_edit?

    data = JSON.parse(params[:data])
    set_menu_data(data['menu'])
    @menu.save

    # update/remove days
    @days = @menu.menu_days.index_by(&:id)
    @days.each do |id, day|
      day.delete unless data['days'].key?(id.to_s)
    end
    save_days(data['days'])

    # update/remove entities
    @entities = @menu.entities.index_by(&:id)
    @entities.each do |id, entity|
      entity.destroy unless data['entities'].key?(id.to_s)
    end
    entities = data['entities'].values.group_by { |entity| entity['parent_id'].to_s }
    save_entities(entities, '0')

    respond_to do |format|
      format.html do
        back_url = user_signed_in? ? menu_menus_url : guest_owner_menu_path(@menu)
        redirect_to back(back_url), notice: I18n.t('menu.was_updated')
      end
      format.json { head :no_content }
    end
  end

  def products
    data = {}
    data[:product_categories] = Menu::ProductCategory.with_translations(I18n.locale)
    data[:products] = Menu::Product.list_by_user(current_user, I18n.locale)
    data[:dish_categories] = Menu::DishCategory.with_translations(I18n.locale)
    data[:dishes] = Menu::Dish.list_by_user(current_user, I18n.locale)
    data[:dish_products] = Menu::DishProduct.all
    data[:meals] = Menu::Meal.with_translations(I18n.locale)
    render json: data
  end

  def destroy
    menu = Menu::Menu.find(params[:id])
    authorize menu, :destroy?
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
    @menu.description = data['description']
  end

  def save_entities(entities, parent_cid, parent_id = nil)
    return unless entities.key?(parent_cid)

    entities[parent_cid].each do |entity_data|
      if entity_data.key?('new')
        entity = Menu::DayEntity.new
        entity.entity_id = entity_data['entity_id']
        entity.entity_type = entity_data['entity_type']
        entity.day_id = @day_cid_to_id[entity_data['day_id'].to_s]
      elsif @entities.key? entity_data['id']
        entity = @entities[entity_data['id']]
      end

      unless entity.nil?
        entity.parent_id = parent_id
        entity.weight = entity_data['weight']
        entity.custom_name = entity_data['custom_name']
        entity.notes = entity_data['notes']
        entity.sort_order = entity_data['sort_order']
        entity.save if entity.changed? || entity.new_record?
        save_entities(entities, entity_data['id'].to_s, entity.id)
      end
    end
  end

  def save_days(days)
    @day_cid_to_id = {}
    days.each do |day_id, day_data|
      if day_data.key?('new')
        day = Menu::Day.new
        day.menu = @menu
      elsif @days.key?(day_id.to_i)
        day = @days[day_id.to_i]
      end

      unless day.nil?
        day.num = day_data['num']
        day.coverage = day_data['coverage']
        day.notes = day_data['notes']
        day.save if day.changed? || day.new_record?
        @day_cid_to_id[day_id] = day.id
      end
    end
  end

  def set_show_breadcrumbs
    add_breadcrumb t('menu.title'), menu_dashboard_path
    if @menu.owner?(current_user)
      add_breadcrumb t('menu.my_menu'), my_menu_menus_path
    elsif @menu.is_public?
      add_breadcrumb t('menu.examples'), examples_menu_menus_path
    end
    add_breadcrumb @menu.name
  end

  def catch_not_found
    yield
  rescue ActiveRecord::RecordNotFound
    redirect_to menu_menus_url, flash: { error: t('site.not_found') }
  end
end
