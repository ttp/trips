class Menu::MealPolicy <  ApplicationPolicy
  def permitted_attributes
    with_locales('name')
  end
end
