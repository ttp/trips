require 'rails_helper'

feature 'Create menu', js: true do
  scenario 'Guest creates menu' do
    visit menu_dashboard_path

    click_link 'Create menu'
    fill_in 'name', with: 'Guest menu'
    click_button 'Save'

    menu = Menu::Menu.find_by(name: 'Guest menu')
    expect(current_path).to eq menu_menu_path(menu)
    expect(page).to have_link('Edit')
  end

  scenario 'Menu with notes' do
    meal = create :menu_meal
    dish_category = create :menu_dish_category, :with_dishes

    visit menu_dashboard_path
    click_link 'Create menu'
    fill_in 'name', with: 'Menu'

    day_el = find('.days .day', match: :first)

    # Add day note
    day_note = 'Day note'
    add_day_note(day_el, day_note)
    save_screenshot '/home/ttp/page.png'
    expect(day_el).to have_css('.notes-text', text: day_note, visible: true)

    # Drag meal
    drag_meal(day_el, meal)
    expect(day_el).to have_content meal.name
    # Add meal note
    meal_note = 'Meal note'
    meal_entity = entity_el(meal)
    add_entity_note(meal_entity, meal_note)
    expect(meal_entity).to have_css('.notes-text', text: meal_note, visible: true)

    # Drag dish
    dish = dish_category.dishes.first
    drag_dish(meal, dish_category, dish)
    expect(day_el).to have_content dish.name
    # Add dish note
    dish_note = 'Dish note'
    dish_entity = entity_el(dish)
    add_entity_note(dish_entity, dish_note)
    expect(day_el).to have_css('.notes-text', text: dish_note, visible: true)

    # Add menu description
    menu_description = 'Menu description'
    click_link I18n.t('menu.description')
    fill_in 'menu_menu_description', with: menu_description

    click_button 'Save'
    expect(page).to have_content day_note
    expect(page).to have_content meal_note
    expect(page).to have_content dish_note
    expect(page).to have_content menu_description
  end

  private

  def drag_meal(day, meal)
    meal_el = find('#meal_list .meal', text: meal.name)
    meal_el.drag_to(day)
  end

  def entity_el(entity)
    entity_name_el = find('.entity-name', text: entity.name, visible: true, match: :first)
    entity_name_el.find(:xpath, '..').find(:xpath, '..')
  end

  def drag_dish(meal, category, dish)
    find('.sidebar a[href="#dish_list"]').click # switch to dishes list
    find('.category-name', text: category.name).click # expand category
    dish_el = find('.items .dish', text: dish.name)
    entity_el = entity_el(meal)
    dish_el.drag_to(entity_el)
  end

  def add_day_note(day_node, note)
    day_node.find('.panel-heading button.notes').click
    day_node.find('textarea', visible: true).set(note)
    blur_note_textarea
  end

  def add_entity_note(entity_node, note)
    entity_node.find('.header', match: :first).find('button.notes').click
    textarea = entity_node.find('textarea', visible: true)
    textarea.set(note)
    blur_note_textarea
  end

  def blur_note_textarea
    page.execute_script "$('.day textarea:visible').trigger('blur')"
  end
end
