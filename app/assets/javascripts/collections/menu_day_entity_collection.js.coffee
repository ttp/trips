#= require models/menu_day_entity_model
_.namespace "App.collections"
(->
  App.collections.MenuDayEntityCollection = new (Backbone.Collection.extend(
    model: App.models.MenuDayEntityModel
    initialize: ->
      @on "remove", @removeChildren, this

    removeChildren: (entity) ->
      @remove @where(parent_id: entity.id)

    tree: (day_id, parent_id = 0, json = false) ->
      entities = @where(day_id: day_id)
      if json
        entities = _.map entities, (entity) -> entity.toJSON()
      flat_tree = _.groupBy entities, (entity) -> if json then entity.parent_id else entity.get('parent_id')
      @_flat_tree_to_tree(flat_tree, parent_id)

    _flat_tree_to_tree: (flat_tree, parent_id) ->
      _.map(flat_tree[parent_id], (entity) ->
        entity: entity,
        children: @_flat_tree_to_tree(flat_tree, entity.id) if flat_tree[entity.id]
      , this)
  ))
)()
