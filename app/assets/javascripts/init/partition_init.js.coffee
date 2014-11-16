#= require views/menu/partition/menu_partition_view
#= require views/menu/partition/menu_partition_porters_list_view
$ ->
  $.ajax
    url: "/menu/menus/products"
    type: "GET"
    dataType: "json"
    success: (data) ->
      App.collections.MenuProductCategoryCollection.reset data["product_categories"]
      App.collections.MenuProductCollection.reset data["products"]
      App.collections.MenuDishCategoryCollection.reset data["dish_categories"]
      App.collections.MenuDishCollection.reset data["dishes"]
      App.collections.MenuDishProductCollection.reset data["dish_products"]
      App.collections.MenuMealCollection.reset data["meals"]

      if $("#porters").length > 0
        App.collections.MenuPartitionPorterCollection.reset JSON.parse($("#porters").html())
        App.collections.MenuPartitionPorterDayEntityCollection.reset JSON.parse($("#porters_products").html())

      partitionView = new App.views.MenuPartitionView(
        menu: JSON.parse($("#menu_item").html())
        days: JSON.parse($("#menu_days").html())
        entities: JSON.parse($("#menu_entities").html())
      )
      partitionView.render()

      portersView = new App.views.MenuPartitionPortersListView
      portersView.render()

    context: this


