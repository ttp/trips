#= require collections/menu_partition_porter_day_entity_collection
#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection

_.namespace "App.models"
(->
  days = App.collections.MenuDayCollection
  porter_entities = App.collections.MenuPartitionPorterDayEntityCollection
  entities = App.collections.MenuDayEntityCollection
  num = 1
  names = ['Тарас', "Костя", "Рома", "Сіма", "Оля"]
  App.models.MenuPartitionPorterModel = Backbone.Model.extend(
    initialize: ->
      unless @id

        @set "id", @cid
        @set "new", 1
        if num <= 5
          @set 'name', names[num - 1]
        else
          @set 'name', "User" + num
        num++
      @porters = App.collections.MenuPartitionPorterCollection
      @on 'remove', @onRemove, this

    name: ->
      @get('name')

    porter_entities: ->
      porter_entities.where(partition_porter_id: @get('id'))

    currently_weight: (current_day) ->
      cnt = @porters.length
      total = 0
      _.each @porter_entities(), (porter_entity) ->
        entity = entities.get(porter_entity.get('day_entity_id'))
        entity_day = days.get(entity.get('day_id'))
        return true if entity_day.get('num') > current_day.get('num')
        total += entity.get('weight') * cnt
      , this
      total

    today_weight: (current_day) ->
      cnt = @porters.length
      total = 0
      _.each @porter_entities(), (porter_entity) ->
        entity = entities.get(porter_entity.get('day_entity_id'))
        entity_day = days.get(entity.get('day_id'))
        return true if entity_day.get('num') != current_day.get('num')
        total += entity.get('weight') * cnt
      , this
      total

    total_weight: ->
      cnt = @porters.length
      total = 0
      _.each @porter_entities(), (porter_entity) ->
        entity = entities.get(porter_entity.get('day_entity_id'))
        total += entity.get('weight') * cnt
      , this
      total

    onRemove: ->
      porter_entities.remove porter_entities.where(partition_porter_id: @get('id'))
  )
)()
