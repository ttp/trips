#= require models/menu_partition_porter_day_entity_model

_.namespace "App.collections"
(->
  App.collections.MenuPartitionPorterDayEntityCollection = new (Backbone.Collection.extend(
    model: App.models.MenuPartitionPorterDayEntityModel

    total_weight: ->

    byEntity: (entity) ->
      @findWhere(day_entity_id: entity.get('id'))
  ))
)()
