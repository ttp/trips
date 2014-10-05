_.namespace "App.models"
(->
  App.models.MenuPartitionPorterDayEntityModel = Backbone.Model.extend(
    initialize: (options) ->
      unless @id
        @set "id", @cid
        @set "new", 1

    porter: ->
      App.collections.MenuPartitionPorterCollection.get(@get('partition_porter_id'))

    porter_entities: ->
      App.collections.MenuPartitionPorterDayEntityCollection.byPorterEntity(this)

    day_entity: ->
      App.collections.MenuDayEntityCollection.get(@get('day_entity_id'))

    weight: ->
      entities = @porter_entities()
      weight = @sharedWeight(entities.length)
      is_first_porter = entities.indexOf(this) == 0
      if is_first_porter then weight.first_porter else weight.per_porter

    sharedWeight: (entity_porters_count) ->
      total_weight = @day_entity().totalWeightByAllPorters()
      weight_per_porter = Math.round(total_weight / entity_porters_count)
      first_porter_weight = total_weight - (weight_per_porter * (entity_porters_count - 1))
      per_porter: weight_per_porter, first_porter: first_porter_weight
  )
)()
