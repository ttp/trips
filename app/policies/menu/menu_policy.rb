class Menu::MenuPolicy
  attr_reader :user, :menu

  def initialize(user, menu)
    @user = user || User.new
    @menu = menu
  end

  def show?(key = nil)
    menu.is_public? || user.admin? || menu.owner?(user) ||
      [menu.edit_key, menu.read_key].include?(key)
  end

  def edit?(key = nil)
    user.admin? || menu.owner?(user) || menu.edit_key == key
  end

  def manage_partitions?
    user.admin? || menu.owner?(user)
  end

  def view_all?
    user.admin?
  end

  def destroy?
    user.admin? || menu.owner?(user)
  end
end