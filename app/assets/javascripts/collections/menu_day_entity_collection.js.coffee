#= require models/menu_day_entity_model
_.namespace "App.collections"
(->
  App.collections.MenuDayEntityCollection = new (Backbone.Collection.extend(
    model: App.models.MenuDayEntityModel
    initialize: ->
      @on "remove", @removeChildren, this

    removeChildren: (entity) ->
      @remove @where(parent_id: entity.id)
  ))
)()
