_.namespace "App.collections"
(->
  App.collections.MenuProductCollection = new (Backbone.Collection.extend
    comparator: (item) -> item.get "name"
    typeahead: ->
      @typeahead_list ||= @map (item) -> id: item.id, name: item.get('name'), entity_type: 3
  )
)()
