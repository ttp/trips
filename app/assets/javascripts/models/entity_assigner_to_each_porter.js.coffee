_.namespace "App.models"

class App.models.EntityAssignerToEachPorter
  constructor: (entity) ->
    @days = App.collections.MenuDayCollection
    @entity = entity
    @entities = App.collections.MenuDayEntityCollection.allAs(entity)
    @porters = App.collections.MenuPartitionPorterCollection
    @porterEntities = App.collections.MenuPartitionPorterDayEntityCollection

  initCache: ->
    product = @entity.getEntityModel()
    @cachedPorters = []
    @porters.each (porter) ->
      @cachedPorters.push porter: porter, weight: porter.productTotalWeight(product)
    , this

  assign: ->
    @initCache()
    _.each(@sortByDay(@entities), (entity) ->
      if @porterEntities.byEntity(entity).length == 0
        cachedPorter = @porterWithMinWeight()
        @createUserEntity(cachedPorter, entity)
        @addTotalWeight(cachedPorter, entity)
    , this)

  sortByDay: (entities) ->
    _.sortBy entities, (entity) -> entity.day().get('num')

  porterWithMinWeight: ->
    _.min @cachedPorters, (cachedPorter) -> cachedPorter.weight

  createUserEntity: (cachedPorter, entity) ->
    porter = cachedPorter.porter
    porterEntity = new App.models.MenuPartitionPorterDayEntityModel
      partition_porter_id: porter.get('id')
      day_entity_id: entity.get('id')
    @porterEntities.push porterEntity

  addTotalWeight: (cachedPorter, entity) ->
    cachedPorter.weight += entity.get('weight') * @cachedPorters.length