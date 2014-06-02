#= require collections/menu_product_category_collection
#= require collections/menu_product_collection
#= require collections/menu_dish_product_collection
#= require models/menu_dish_product_model
#= require typeahead

_.namespace "App.views"
(->
  App.views.MenuDishProductsView = Backbone.View.extend(
    events:
      "click button.remove": "removeProduct"

    initialize: (options) ->
      @bindEvents()
      @render options.dish_products

    render: (dish_products) ->
      _.each dish_products, (item, key) ->
        dish_product = new App.models.MenuDishProductModel(product_id: key, weight: item)
        @renderProduct(dish_product)
      , this

    renderProduct: (dish_product) ->
      return if @$el.find("#product_#{dish_product.get('product_id')}").length

      @$el.find('.noitems').hide()

      $product = $(JST["templates/food/dish_product"](dish_product: dish_product, product: dish_product.product()))
      @$el.find('.body').append $product

      $product.find("button.info").tooltip
        animation: false
        html: true
        placement: "bottom"
        container: "body"


    bindEvents: ->
      @$el.find('.body').droppable
        drop: $.proxy(@onDrop, this)
        activeClass: "ui-state-hover"
        hoverClass: "ui-state-active"

      @$el.find('.body').sortable()

      @initTypeahead(@$el.find('.panel-heading input.quick-add'))

    initTypeahead: (input) ->
      input.typeahead(@getTypeaheadConf())
      input.on('typeahead:selected typeahead:autocompleted', $.proxy((event, obj) ->
        @addProduct(obj.id)
        $(event.currentTarget).val('').typeahead('setQuery', '')
        false
      , this))

    getTypeaheadConf: ->
      local: App.collections.MenuProductCollection.typeahead()
#      header: "<div class='dropdown-header'>#{I18n.t('menu.products.products')}</div>"
      items: 5,
      minLength: 3,
      valueKey: 'name'

    toggleToolbar: (event) ->
      $(event.target).closest('.toolbar').toggleClass('focus');

    removeProduct: (e) ->
      $(e.target).closest('.product').remove()

    onDrop: (event, ui) ->
      @addProduct(ui.draggable.data("id")) if ui.draggable.data("id")

    addProduct: (product_id) ->
      dish_product = new App.models.MenuDishProductModel(
        product_id: product_id
      )
      dish_product.set('weight', dish_product.product().get('norm'))
      @renderProduct dish_product
  )
)()
