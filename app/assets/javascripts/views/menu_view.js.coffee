#= require views/menu_day_view
#= require views/menu_products_view
#= require views/menu_dishes_view
#= require views/menu_meals_view
#= require models/menu_model
#= require models/menu_day_model
#= require collections/menu_day_collection
#= require collections/menu_product_category_collection
#= require collections/menu_product_collection
#= require collections/menu_dish_category_collection
#= require collections/menu_dish_collection
#= require collections/menu_dish_product_collection
#= require collections/menu_meal_collection
#= require libs/rivets.min
#= require libs/rivets-backbone
#= require libs/rivets-formatters
_.namespace "App.views"
(->
  App.views.MenuView = Backbone.View.extend(
    el: "#menu"
    events:
      "click button.add-day": "createDay"
      "click button.save": "save"

    initialize: (options) ->
      @menu = new App.models.MenuModel(options.menu)
      @days = App.collections.MenuDayCollection
      @days.reset options.days
      @entities = App.collections.MenuDayEntityCollection
      @entities.reset options.entities
      @bindEvents()

    bindEvents: ->
      rivets.bind @$el,
        menu: @menu

      @days.bind "add remove change", @updateDaysCount, this

    render: ->
      @days.each ((day) ->
        dayView = new App.views.MenuDayView(
          el: @createDayEl()
          model: day
        )
      ), this

    createDayEl: ->
      dayEl = $("<div class='popover'></div>")
      @$el.find("div.days").append dayEl
      dayEl

    createDay: (e) ->
      e.preventDefault()
      dayEl = @createDayEl()
      day = new App.models.MenuDayModel(num: App.collections.MenuDayCollection.size() + 1)
      @days.add day
      dayView = new App.views.MenuDayView(
        el: dayEl
        model: day
      )

    updateDaysCount: ->
      sum = @days.reduce((memo, day) ->
        memo + day.get("rate")
      , 0)
      @menu.set "days_count", sum

    save: (e) ->
      menu_data =
        menu: @menu.toJSON()
        days: _.indexBy(@days.toJSON(), "id")
        entities: _.indexBy(@entities.toJSON(), "id")

      @$el.find("textarea.hide").val JSON.stringify(menu_data)
  )
)()
