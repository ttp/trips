_.namespace "App.views"
(->
  App.views.MenuDishesView = Backbone.View.extend(
    events:
      "click .category-name": "toggleDishes"

    initialize: (options) ->
      @categories = options.categories
      @dishes = options.dishes
      @render()

    renderDishes: (category, categoryEl) ->
      dishesRoot = $("<ul></ul>").addClass("items")
      dishes = @dishes.where(dish_category_id: category.id)
      _.each dishes, ((dish) ->
        dishLiEl = $("<li></li>")
        dishEl = $("<span></span>").addClass("dish")
        dishEl.attr
          "data-id": dish.id
          "data-type": 2

        dishEl.text dish.get("name")
        dishLiEl.append dishEl
        $("<i class=\"glyphicon glyphicon-info-sign\"></i>").attr("title", dish.products_titles().join("<br/>")).appendTo dishLiEl
        dishesRoot.append dishLiEl
      ), this
      categoryEl.append dishesRoot

    render: ->
      rootEl = $("<ul></ul>")
      @categories.each $.proxy((category) ->
        liEl = $("<li></li>").addClass("category")
        $("<i class=\"glyphicon icon-folder glyphicon-folder-close\"></i>").appendTo liEl
        categoryName = $("<span></span>")
        categoryName.text(category.get("name")).addClass("category-name").data "pid", category.id
        liEl.append categoryName
        @renderDishes category, liEl
        rootEl.append liEl
      , this)
      @$el.html ""
      @$el.append rootEl
      @$el.find(".dish").draggable
        revert: "invalid"
        helper: "clone"
        appendTo: "body"
        containment: "#main"
        scroll: false

      @$el.find("i.icon-info-sign").tooltip
        animation: false
        html: true
        placement: "bottom"
        container: "body"


    toggleDishes: (e) ->
      $(e.currentTarget).closest("li").toggleClass("expanded").find("i.icon-folder").toggleClass("glyphicon-folder-close").toggleClass "glyphicon-folder-open"
  )
)()
