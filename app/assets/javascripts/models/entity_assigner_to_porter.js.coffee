_.namespace "App.models"

class App.models.EntityAssignerToPorter
  constructor: (entity, porter) ->
    @porter = porter
    @entities = App.collections.MenuDayEntityCollection.allAs(entity)
    @porterEntities = App.collections.MenuPartitionPorterDayEntityCollection

  assign: ->
    _.each(@entities, (entity) ->
      @cleanAssignedEntity entity
      porter_entity = new App.models.MenuPartitionPorterDayEntityModel
        partition_porter_id: @porter.get('id')
        day_entity_id: entity.get('id')
      @porterEntities.push porter_entity
      true
    , this)

  cleanAssignedEntity: (entity) ->
    @porterEntities.remove @porterEntities.byEntity(entity)