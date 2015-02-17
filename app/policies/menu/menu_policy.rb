class Menu::MenuPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  attr_reader :user, :menu

  def initialize(user, menu)
    @user = user || User.new
    @menu = menu
  end

  def show?(key = nil)
    menu.is_public? || user.admin? || owner? ||
      [menu.edit_key, menu.read_key].include?(key)
  end

  def edit?(key = nil)
    user.admin? || owner? || menu.edit_key == key
  end

  def owner?
    menu.owner?(user)
  end

  def manage_partitions?
    user.admin? || owner?
  end

  def view_all?
    user.admin?
  end

  def destroy?
    user.admin? || owner?
  end
end
