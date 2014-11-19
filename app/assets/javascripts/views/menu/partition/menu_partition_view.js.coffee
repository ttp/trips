#= require views/menu/partition/menu_partition_day_view
#= require models/menu_model
#= require models/menu_day_model
#= require models/menu_partition_auto_splitter
#= require collections/menu_day_collection
#= require collections/menu_product_category_collection
#= require collections/menu_product_collection
#= require collections/menu_dish_category_collection
#= require collections/menu_dish_collection
#= require collections/menu_dish_product_collection
#= require collections/menu_meal_collection
#= require collections/menu_partition_porter_collection
#= require collections/menu_partition_porter_day_entity_collection

_.namespace "App.views"
(->
  App.views.MenuPartitionView = Backbone.View.extend(
    el: "#menu"
    events:
      "click button.save": "save"

    initialize: (options) ->
      @model = @menu = new App.models.MenuModel(options.menu)
      @days = App.collections.MenuDayCollection
      @days.reset options.days
      @entities = App.collections.MenuDayEntityCollection
      @entities.reset options.entities

    render: ->
      @days.each ((day) ->
        dayView = new App.views.MenuPartitionDayView
          id: "day-#{day.id}"
          model: day,
          renderTo: @$el.find(".tab-content"),
          renderTabTo: @$el.find(".nav-tabs")
        dayView.show()
      ), this
      @$el.find('.nav-tabs li:eq(0) a').tab('show')

    save: (e) ->
      data =
        porters: _.indexBy(App.collections.MenuPartitionPorterCollection.toJSON(), 'id')
        porter_products: App.collections.MenuPartitionPorterDayEntityCollection.toJSON()
      @$el.find("textarea.hide").val JSON.stringify(data)
  )
)()