#= require classes/loading_spin
#= require backbone-validation
#= require views/menu/partition/menu_partition_view
#= require views/menu/partition/menu_partition_porters_list_view
#= require views/menu/partition/menu_partition_graph_view
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

    graphView = new App.views.MenuPartitionGraphView
    spinner.stop()
