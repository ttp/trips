#= require models/menu_day_model
#= require collections/menu_day_entity_collection
_.namespace "App.collections"
(->
  App.collections.MenuDayCollection = new (Backbone.Collection.extend(
    model: App.models.MenuDayModel
    initialize: ->
      @entities = App.collections.MenuDayEntityCollection
      @on "remove", @removeEntities, this

    removeEntities: (day) ->
      @entities.remove @entities.where(day_id: day.id)
  ))
)()
