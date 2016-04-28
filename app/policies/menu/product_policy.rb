class Menu::ProductPolicy <  ApplicationPolicy
  def show?
    admin? || record.is_public? || owner?  || user.moderator?
  end

  def create?
    !guest?
  end

  def update?
    admin? || owner? || user.moderator?
  end

  def destroy?
    admin? || owner? || user.moderator?
  end

  def make_public?
    admin? || user.moderator?
  end

  def change_icon?
    admin? || user.moderator? || owner?
  end

  def permitted_attributes
    attributes = [:calories, :proteins, :fats, :carbohydrates, :product_category_id, :norm, :photo] +
                 with_locales('name', 'description', 'norm_info')
    attributes += [:is_public] if admin? || user.moderator?
    attributes
  end

  class Scope < Scope
    def resolve
      return scope if user.admin? || user.moderator?
      return scope.is_public if guest?
      scope.for_user(user)
    end
  end
end
