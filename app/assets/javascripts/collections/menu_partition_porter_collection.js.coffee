#= require models/menu_partition_porter_model
#= require collections/menu_partition_porter_day_entity_collection
_.namespace "App.collections"
(->
  App.collections.MenuPartitionPorterCollection = new (Backbone.Collection.extend(
    model: App.models.MenuPartitionPorterModel
    initialize: ->
      @entities = App.collections.MenuPartitionPorterDayEntityCollection
      @on "remove", @removeEntities, this

    comparator: (porter) ->
      porter.get 'position'

    removeEntities: (porter) ->
      @entities.remove @entities.where(porter_id: porter.id)
  ))
)()
