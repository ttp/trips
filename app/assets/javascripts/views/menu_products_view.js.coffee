_.namespace "App.views"
(->
  App.views.MenuProductsView = Backbone.View.extend(
    events:
      "click .category-name": "toggleProducts"
      "click i.glyphicon-folder": "toggleProducts"

    initialize: (options) ->
      @categories = options.categories
      @products = options.products
      @render()

    render: ->
      rootEl = $("<ul></ul>")
      @categories.each $.proxy((category) ->
        products = @products.where(product_category_id: category.id)
        liEl = $("<li></li>").addClass("category")
        $("<i class=\"glyphicon glyphicon-folder glyphicon-folder-close\"></i>").appendTo liEl
        categoryName = $("<span></span>")
        categoryName.text(category.get("name")).addClass("category-name").data "pid", category.id
        liEl.append categoryName
        productsRoot = $("<ul></ul>").addClass("items")
        _.each products, ((product) ->
          productLiEl = $("<li></li>")

          productEl = $("<span></span>").addClass("product").text(product.get("name")).attr
            "data-id": product.id
            "data-type": "3"
          productEl.appendTo productLiEl

          $("<i class=\"glyphicon glyphicon-info-sign\"></i>")
            .attr("title", product.infoText().join("<br/>"))
            .appendTo productLiEl

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

      @$el.find("i.glyphicon-info-sign").tooltip
        animation: false
        html: true
        placement: "bottom"
        container: "body"


    toggleProducts: (e) ->
      $(e.currentTarget).closest("li").toggleClass("expanded").find("i.glyphicon-folder").toggleClass("glyphicon-folder-close").toggleClass "glyphicon-folder-open"
  )
)()
