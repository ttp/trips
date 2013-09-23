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
#= require libs/backbone-validation
_.namespace "App.views"
(->
  App.views.MenuView = Backbone.View.extend(
    el: "#menu"
    events:
      "click button.add-day": "createDay"
      "click button.save": "save"

    initialize: (options) ->
      @model = @menu = new App.models.MenuModel(options.menu)
      @days = App.collections.MenuDayCollection
      @days.reset options.days
      @entities = App.collections.MenuDayEntityCollection
      @entities.reset options.entities
      @bindEvents()

    bindEvents: ->
      rivets.bind @$el,
        menu: @menu
      Backbone.Validation.bind this,
        valid: @valid
        invalid: @invalid
      @days.bind "add remove change", @updateDaysCount, this

    valid: (view, attr) ->
      view.$el.find("input[name=#{attr}]").removeClass('error').attr('title', '')
    invalid: (view, attr, error) ->
      view.$el.find("input[name=#{attr}]").addClass('error').attr('title', I18n.t(error))

    render: ->
      @days.each ((day) ->
        dayView = new App.views.MenuDayView
          id: "day-#{day.id}"
          model: day,
          renderTo: @$el.find(".tab-content"),
          renderTabTo: @$el.find(".nav-tabs")
        dayView.show()
      ), this
      @$el.find('.nav-tabs li:eq(1) a').tab('show')

    createDay: (e) ->
      e.preventDefault()
      day = new App.models.MenuDayModel(num: App.collections.MenuDayCollection.size() + 1)
      @days.add day
      dayView = new App.views.MenuDayView(
        id: "day-#{day.id}"
        model: day
        renderTo: @$el.find(".tab-content"),
        renderTabTo: @$el.find(".nav-tabs")
      )
      dayView.show()

    updateDaysCount: ->
      sum = @days.reduce((memo, day) ->
        memo + day.get("coverage")
      , 0)
      @menu.set "coverage", sum
      @menu.set "days_count", @days.length

    save: (e) ->
      @menu.validate()
      if @$el.find('input.error').length > 0
        alert(I18n.t('menu.validation.fix_errors'))
        return false
      menu_data =
        menu: @menu.toJSON()
        days: _.indexBy(@days.toJSON(), "id")
        entities: _.indexBy(@entities.toJSON(), "id")

      @$el.find("textarea.hide").val JSON.stringify(menu_data)
  )
)()
