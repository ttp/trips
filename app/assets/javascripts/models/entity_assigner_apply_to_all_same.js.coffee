_.namespace "App.models"

class App.models.EntityAssignerApplyToAllSame
  constructor: (entity) ->
    @entity = entity
    @entities = App.collections.MenuDayEntityCollection.allAs(entity)
    @porterEntities = App.collections.MenuPartitionPorterDayEntityCollection
    @porters = @porterEntities.byEntity(entity).map (porterEntity) -> porterEntity.porter()

  assign: ->
    _.each(@entities, (entity) ->
      @cleanAssignedEntity entity
      _.each(@porters, (porter) ->
        porter_entity = new App.models.MenuPartitionPorterDayEntityModel
          partition_porter_id: porter.get('id')
          day_entity_id: entity.get('id')
        @porterEntities.push porter_entity
        true
      , this)
      true
    , this)

  cleanAssignedEntity: (entity) ->
    @porterEntities.remove @porterEntities.byEntity(entity)
