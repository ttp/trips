#= require collections/menu_partition_porter_day_entity_collection
#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection

_.namespace "App.models"
(->
  days = App.collections.MenuDayCollection
  porter_entities = App.collections.MenuPartitionPorterDayEntityCollection
  entities = App.collections.MenuDayEntityCollection
  num = 1
  App.models.MenuPartitionPorterModel = Backbone.Model.extend(
    initialize: ->
      unless @id

        @set "id", @cid
        @set "new", 1
        if @get('name') == ''
          @set 'name', I18n.t('menu.partitions.porter') + num
        num++
      @porters = App.collections.MenuPartitionPorterCollection
      @on 'remove', @onRemove, this

    name: ->
      @get('name')

    porter_entities: ->
      porter_entities.where(partition_porter_id: @get('id'))

    day_entities: ->
      _.map @porter_entities(), (porter_entity)->
        porter_entity.day_entity()

    is_entity_from_day: (entity, day) ->
      entity_day = days.get(entity.get('day_id'))
      entity_day.get('num') == day.get('num')

    products_totals: (current_day) ->
      totals = {}
      _.each @porter_entities(), (porter_entity) ->
        day_entity = porter_entity.day_entity()
        product = day_entity.getEntityModel()
        if !totals[product.get('id')]
          totals[product.get('id')] = product: product, total: 0, today_total: 0, cnt: 0
        record = totals[product.get('id')]
        record.total += porter_entity.weight()
        record.today_total += porter_entity.weight() if @is_entity_from_day(day_entity, current_day)
        record.cnt += 1
      , this
      _.sortBy totals, (item)-> item.product.get('name')

    today_weight: (current_day) ->
      cnt = @porters.length
      total = 0
      _.each @porter_entities(), (porter_entity) ->
        day_entity = porter_entity.day_entity()
        if @is_entity_from_day(day_entity, current_day)
          total += porter_entity.weight()
      , this
      total

    total_weight: ->
      total = 0
      _.each @porter_entities(), (porter_entity) ->
        total += porter_entity.weight()
      , this
      total

    onRemove: ->
      porter_entities.remove porter_entities.where(partition_porter_id: @get('id'))
  )
)()
