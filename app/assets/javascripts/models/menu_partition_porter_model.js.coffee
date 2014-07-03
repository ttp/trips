#= require collections/menu_partition_porter_day_entity_collection
#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection

_.namespace "App.models"
(->
  days = App.collections.MenuDayCollection
  porter_entities = App.collections.MenuPartitionPorterDayEntityCollection
  entities = App.collections.MenuDayEntityCollection
  App.models.MenuPartitionPorterModel = Backbone.Model.extend(
    initialize: ->
      unless @id
        @set "id", @cid
        @set "new", 1

    name: ->
      @get('name') || "User" + @get('position')

    currently_weight: (day) ->
      cnt = days.length
      total = 0
      _.each porter_entities.where(partition_porter_id: @get('id')), (porter_entity) ->
        entity = entities.find(porter_entity.get('id'))
        return true if entity.get('num') > day.get('num')
        total += entity.get('weight') * cnt
      , this
      total

    total_weight: ->
      cnt = days.length
      total = 0
      _.each porter_entities.where(partition_porter_id: @get('id')), (porter_entity) ->
        entity = entities.find(porter_entity.get('id'))
        total += entity.get('weight') * cnt
      , this
      total
  )
)()
