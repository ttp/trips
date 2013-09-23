_.namespace "App.views"
(->
  App.views.MenuMealsView = Backbone.View.extend(
    initialize: (options) ->
      @meals = options.meals
      @render()

    render: ->
      rootEl = $("<div></div>")
      @meals.each $.proxy((meal) ->
        mealEl = $("<div></div>")
        mealEl.addClass("meal").text meal.get("name")
        mealEl.attr
          "data-id": meal.id
          "data-type": 1

        rootEl.append mealEl
      , this)
      @$el.html ""
      @$el.append rootEl
      @$el.find(".meal").draggable
        revert: "invalid"
        helper: "clone"
        appendTo: "body"
        containment: "#main"
        scroll: false

  )
)()
