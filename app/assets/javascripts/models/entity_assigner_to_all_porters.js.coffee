_.namespace "App.models"

class App.models.EntityAssignerToAllPorters
  constructor: (entity, porters) ->
    @porters = porters
    @entity = entity
    @porterEntities = App.collections.MenuPartitionPorterDayEntityCollection

  assign: ->
    @cleanAssignedEntity @entity
    _.each(@porters, (porter) ->
      porter_entity = new App.models.MenuPartitionPorterDayEntityModel
        partition_porter_id: porter.get('id')
        day_entity_id: @entity.get('id')
      @porterEntities.push porter_entity
      true
    , this)

  cleanAssignedEntity: (entity) ->
    @porterEntities.remove @porterEntities.byEntity(entity)
