_.namespace "App.models"

class App.models.MenuPartitionAutoSplitter
  constructor: ->
    @days = App.collections.MenuDayCollection
    @entities = App.collections.MenuDayEntityCollection
    @porters = App.collections.MenuPartitionPorterCollection
    @porterEntities = App.collections.MenuPartitionPorterDayEntityCollection

  initUsers: ->
    @users = []
    @porters.each (porter) ->
      @users.push porter: porter, weight: porter.total_weight(), name: porter.get('name')
    , this

  split: ->
    @initUsers()
    @days.each((day) ->
      _.each(@sortedDayEntities(day), (entity) ->
        if @porterEntities.byEntity(entity).length == 0
          user = @userWithMinWeight()
          @createUserEntity(user, entity)
          @addTotalWeight(user, entity)
      , this)
    , this)

  userWithMinWeight: ->
    _.min @users, (user) -> user.weight * 100 / user.porter.get('weight_rank')

  sortedDayEntities: (day) ->
    dayEntities = @entities.where(day_id: day.get('id'), entity_type: 3)
    _.sortBy dayEntities, (entity) -> entity.get('weight') * -1

  createUserEntity: (user, entity) ->
    porter = user.porter
    porterEntity = new App.models.MenuPartitionPorterDayEntityModel
      partition_porter_id: porter.get('id')
      day_entity_id: entity.get('id')
    @porterEntities.push porterEntity

  addTotalWeight: (user, entity) ->
    user.weight += entity.get('weight') * @users.length