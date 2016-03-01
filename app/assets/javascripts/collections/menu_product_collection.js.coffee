#= require models/menu_product_model
(->
  _.namespace "App.collections"
  App.collections.MenuProductCollection = new (Backbone.Collection.extend
    model: App.models.MenuProductModel
    url: '/api/v1/menu/products'
    comparator: (item) -> item.get "name"
    typeahead: ->
      @typeahead_list ||= @map (item) -> id: item.id, name: item.get('name'), entity_type: 3
  )
)()
