#= require models/menu_partition_porter_day_entity_model

_.namespace "App.collections"
(->
  App.collections.MenuPartitionPorterDayEntityCollection = new (Backbone.Collection.extend(
    model: App.models.MenuPartitionPorterDayEntityModel

    byEntity: (entity) ->
      @where(day_entity_id: entity.get('id'))

    byPorterEntity: (porter_entity) ->
      @where(day_entity_id: porter_entity.get('day_entity_id'))
  ))
)()
