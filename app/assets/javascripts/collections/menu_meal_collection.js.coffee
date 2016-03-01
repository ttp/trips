_.namespace "App.collections"
(->
  App.collections.MenuMealCollection = new(Backbone.Collection.extend
    url: '/api/v1/menu/meals'
    typeahead: ->
      @typeahead_list ||= @map (item) -> id: item.id, name: item.get('name'), entity_type: 1
  )
)()
