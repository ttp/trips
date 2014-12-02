class Menu::DishPolicy <  ApplicationPolicy
  def show?
    admin? || record.is_public? || owner?
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
    admin? || user.moderator?
  end

  class Scope < Scope
    def resolve
      return scope if user.admin? || user.moderator?
      return scope.public if guest?
      scope.for_user(user)
    end
  end
end