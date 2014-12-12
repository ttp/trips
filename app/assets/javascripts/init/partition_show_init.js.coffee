#= require collections/menu_day_collection
#= require collections/menu_partition_porter_collection
#= require collections/menu_partition_porter_day_entity_collection
#= require views/menu/partition/menu_partition_graph_view

$ ->
  App.collections.MenuPartitionPorterCollection.reset JSON.parse($("#porters").html())
  App.collections.MenuPartitionPorterDayEntityCollection.reset JSON.parse($("#porters_products").html())
  App.collections.MenuDayCollection.reset JSON.parse($("#menu_days").html())
  App.collections.MenuDayEntityCollection.reset JSON.parse($("#menu_entities").html())
  $('a[href="#products_partition"]').click _.once(->
    setTimeout(->
      graphView = new App.views.MenuPartitionGraphView
    , 10)
  )
