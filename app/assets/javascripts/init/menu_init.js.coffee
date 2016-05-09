#= require classes/loading_spin
#= require views/menu_view
#= require backbone-validation
$ ->
  spinner = new App.LoadingSpin($('#menu .days .tab-content')[0])
  spinner.start()

  Backbone.Validation.configure
    forceUpdate: true

  localeData = data: { locale: I18n.locale }
  loadings = [
    App.collections.MenuProductCategoryCollection.fetch(localeData),
    App.collections.MenuProductCollection.fetch(localeData),
    App.collections.MenuDishCategoryCollection.fetch(localeData),
    App.collections.MenuDishCollection.fetch(localeData),
    App.collections.MenuDishProductCollection.fetch(localeData),
    App.collections.MenuMealCollection.fetch(localeData)
  ]
  $.when.apply($, loadings).then ->
    productsView = new App.views.MenuProductsView(
      el: "#product_list"
      categories: App.collections.MenuProductCategoryCollection
      products: App.collections.MenuProductCollection
    )
    dishesView = new App.views.MenuDishesView(
      el: "#dish_list"
      categories: App.collections.MenuDishCategoryCollection
      dishes: App.collections.MenuDishCollection
    )
    mealsView = new App.views.MenuMealsView(
      el: "#meal_list"
      meals: App.collections.MenuMealCollection
    )
    menuView = new App.views.MenuView(
      menu: JSON.parse($("#menu_item").html())
      days: JSON.parse($("#menu_days").html())
      entities: JSON.parse($("#menu_entities").html())
    )
    menuView.createDay() if menuView.days.length == 0

    menuProductsList = React.createFactory(MenuProductsList)
    ReactDOM.render(
      menuProductsList({ entities: menuView.entities }),
      document.getElementById("menu-products")
    )
    spinner.stop()
