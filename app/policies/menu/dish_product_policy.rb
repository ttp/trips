class Menu::DishProductPolicy <  ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.is_public if guest?
      scope.for_user(user)
    end
  end
end
