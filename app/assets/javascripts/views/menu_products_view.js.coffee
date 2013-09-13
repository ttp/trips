_.namespace "App.views"
(->
  App.views.MenuProductsView = Backbone.View.extend(
    events:
      "click .category-name": "toggleProducts"

    initialize: (options) ->
      @categories = options.categories
      @products = options.products
      @render()

    render: ->
      rootEl = $("<ul></ul>")
      @categories.each $.proxy((category) ->
        products = @products.where(product_category_id: category.id)
        liEl = $("<li></li>").addClass("category")
        $("<i class=\"icon-folder-close\"></i>").appendTo liEl
        categoryName = $("<span></span>")
        categoryName.text(category.get("name")).addClass("category-name").data "pid", category.id
        liEl.append categoryName
        productsRoot = $("<ul></ul>").addClass("items")
        _.each products, ((product) ->
          productLiEl = $("<li></li>")
          productEl = $("<span></span>").addClass("product")
          productEl.attr
            "data-id": product.id
            "data-type": "3"

          productEl.text product.get("name")
          productLiEl.append productEl
          productsRoot.append productLiEl
        ), this
        liEl.append productsRoot
        rootEl.append liEl
      , this)
      @$el.html ""
      @$el.append rootEl
      @$el.find(".product").draggable
        revert: "invalid"
        helper: "clone"
        appendTo: "body"
        containment: "#main"
        scroll: false


    toggleProducts: (e) ->
      $(e.currentTarget).closest("li").toggleClass("expanded").find("i").toggleClass("icon-folder-closed").toggleClass "icon-folder-open"
  )
)()
