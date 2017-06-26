class Menu::PartitionsController < ApplicationController
  include MenusHelper
  include Menu::PartitionsHelper

  before_action :authenticate_user!
  before_action :find_menu
  before_action :find_partition, only: [:show, :edit, :update, :destroy]
  before_action :authorize_menu!

  def show
    set_breadcrumbs

    @menu.users_count = @partition.partition_porters.count
    render 'menu/menus/show'
  end

  def new
    @partition = Menu::Partition.new
  end

  def create
    data = JSON.parse(params[:data])
    @partition = @menu.partitions.create
    save_porters(data['porters']) if data['porters'].present?
    save_products(data['porter_products']) if data['porter_products'].present?
    redirect_to menu_menu_partition_path(@menu, @partition)
  end

  def edit
  end

  def update
    data = JSON.parse(params[:data])
    @porters = @partition.partition_porters.index_by(&:id)
    remove_porters(data['porters']) if data['porters'].present?
    save_porters(data['porters']) if data['porters'].present?
    save_products(data['porter_products']) if data['porter_products'].present?
    @partition.touch
    redirect_to menu_menu_partition_path(@menu, @partition)
  end

  def destroy
    @partition.destroy
    redirect_to menu_menu_path(params[:menu_id])
  end

  private

  def find_menu
    @menu = Menu::Menu.find(params[:menu_id])
  end

  def find_partition
    @partition = Menu::Partition.find(params[:id])
  end

  def save_porters(porters)
    porters.each do |porter_id, porter_data|
      if porter_data.key?('new')
        porter = @partition.partition_porters.build
      elsif @porters.present? && @porters.key?(porter_id.to_i)
        porter = @porters[porter_id.to_i]
      end

      save_porter(porter, porter_data) if porter.present?
    end
  end

  def remove_porters(porters)
    @porters.each do |_id, porter|
      porter.destroy unless porters.key?(porter.id.to_s)
    end
  end

  def save_porter(porter, porter_data)
    porter.name = porter_data['name']
    porter.save if porter.changed? || porter.new_record?
    cache_porter(porter_data['id'], porter)
  end

  def cache_porter(porter_id, porter)
    @porter_cid_to_porter ||= {}
    @porter_cid_to_porter[porter_id] = porter
  end

  def cached_porters
    @porter_cid_to_porter
  end

  def save_products(porter_entities)
    grouped_entities = porter_entities.group_by { |entity| entity['partition_porter_id'].to_s }
    cached_porters.each do |porter_id, porter|
      if grouped_entities.key? porter_id.to_s
        porter.day_entity_ids = grouped_entities[porter_id.to_s].map { |entity| entity['day_entity_id'] }
      else
        porter.porter_products.destroy_all
      end
    end
  end

  private

  def set_breadcrumbs
    add_breadcrumb t('menu.title'), menu_dashboard_path
    if @menu.owner?(current_user)
      add_breadcrumb t('menu.my_menu'), my_menu_menus_path
    elsif @menu.is_public?
      add_breadcrumb t('menu.examples'), examples_menu_menus_path
    end
    add_breadcrumb @menu.name, menu_menu_path(@menu)
    add_breadcrumb partition_name(@partition)
  end

  def authorize_menu!
    authorize @menu, :manage_partitions?
  end
end
