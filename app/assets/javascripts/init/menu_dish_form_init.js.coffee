#= require views/menu_dish_products_view
#= require views/menu_products_view
$ ->
  $.ajax
    url: "/menu/menus/products"
    type: "GET"
    dataType: "json"
    success: (data) ->
      App.collections.MenuProductCategoryCollection.reset data["product_categories"]
      App.collections.MenuProductCollection.reset data["products"]
      productsView = new App.views.MenuProductsView(
        el: "#product_list"
        categories: App.collections.MenuProductCategoryCollection
        products: App.collections.MenuProductCollection
      )
      dishProductsView = new App.views.MenuDishProductsView(
        el: "#dish_products"
        dish_products: JSON.parse($('#dish_products_map').html())
      )