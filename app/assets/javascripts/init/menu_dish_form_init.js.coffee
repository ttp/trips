#= require views/menu_dish_products_view
#= require views/menu_products_view
$ ->
  localeData = data: { locale: I18n.defaultLocale }
  loadings = [
    App.collections.MenuProductCategoryCollection.fetch(localeData),
    App.collections.MenuProductCollection.fetch(localeData)
  ]
  $.when.apply($, loadings).then ->
    productsView = new App.views.MenuProductsView(
      el: "#product_list"
      categories: App.collections.MenuProductCategoryCollection
      products: App.collections.MenuProductCollection
    )
    dishProductsView = new App.views.MenuDishProductsView(
      el: "#dish_products"
      dish_products: JSON.parse($('#dish_products_map').html())
    )
