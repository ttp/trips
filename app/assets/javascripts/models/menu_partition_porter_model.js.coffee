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
        if @get('name') == ''
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

    day_entities: ->
      _.map @porter_entities(), (porter_entity)->
        entities.get(porter_entity.get('day_entity_id'))

    _is_entity_from_day: (entity, day) ->
      entity_day = days.get(entity.get('day_id'))
      entity_day.get('num') == day.get('num')

    products_totals: (current_day) ->
      cnt = @porters.length
      totals = {}
      _.each @day_entities(), (day_entity) ->
        product = day_entity.getEntityModel()
        if !totals[product.get('id')]
          totals[product.get('id')] = product: product, total: 0, today_total: 0, cnt: 0
        record = totals[product.get('id')]
        record.total += day_entity.get('weight') * cnt
        record.cnt += 1
        if @_is_entity_from_day(day_entity, current_day)
          record.today_total += day_entity.get('weight') * cnt
      , this
      _.sortBy totals, (item)-> item.product.get('name')

    today_weight: (current_day) ->
      cnt = @porters.length
      total = 0
      _.each @day_entities(), (entity) ->
        if @_is_entity_from_day(entity, current_day)
          total += entity.get('weight') * cnt
      , this
      total

    total_weight: ->
      cnt = @porters.length
      total = 0
      _.each @day_entities(), (entity) ->
        total += entity.get('weight') * cnt
      , this
      total

    onRemove: ->
      porter_entities.remove porter_entities.where(partition_porter_id: @get('id'))
  )
)()
