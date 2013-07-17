# encoding: UTF-8

puts 'Menu meals'
Menu::Meal.translation_class.delete_all
Menu::Meal.delete_all

meals = [
  {id: 1, ua: 'Сніданок', ru: 'Завтрак'},
  {id: 2, ua: 'Обід', ru: 'Обед'},
  {id: 3, ua: 'Перекус', ru: 'Перекус'},
  {id: 4, ua: 'Вечеря', ru: 'Ужин'},
  {id: 5, ua: 'Кишенькове харчування', ru: 'Карманное питание'}
]

meals.each do |meal|
  row = Menu::Meal.new
  [:ru,:ua].each do |locale|
    Globalize.with_locale(locale) do
      row.name = meal[locale]
    end
  end
  row.id = meal[:id]
  row.save
end