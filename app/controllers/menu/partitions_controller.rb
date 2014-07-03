class Menu::PartitionsController < ApplicationController
  include MenusHelper

  before_filter :authenticate_user!
  before_filter :find_menu
  before_filter :find_partition, only: [:edit, :update, :destroy]

  def new
    @partition = Menu::Partition.new
  end

  def create

  end

  def edit

  end

  def update

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
end