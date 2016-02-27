class Menu::ProductCategoryPolicy <  ApplicationPolicy
  def permitted_attributes
    with_locales('name')
  end
end
