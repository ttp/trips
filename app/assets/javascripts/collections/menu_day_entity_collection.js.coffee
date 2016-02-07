#= require models/menu_day_entity_model
#= require collections/menu_day_collection
_.namespace "App.collections"
(->
  Days = App.collections.MenuDayCollection;
  App.collections.MenuDayEntityCollection = new (Backbone.Collection.extend(
    model: App.models.MenuDayEntityModel
    initialize: ->
      @on "remove", @removeChildren, this
      @on "remove", @updateSortOrders, this
      @on "add", @initSortOrder, this

    comparator: (entity) ->
      entity.get 'sort_order'

    removeChildren: (entity) ->
      @remove @where(parent_id: entity.id)

    initSortOrder: (entity) ->
      if entity.get('new')
        entity.set('sort_order', @siblings(entity).length - 1)
        @sort()

    updateSortOrders: (entity) ->
      _.each(@siblings(entity), (item, i) ->
        item.set 'sort_order', i
      , this)

    allAs: (day_entity) ->
      @where entity_id: day_entity.get('entity_id'), entity_type: day_entity.get('entity_type')

    siblings: (entity) ->
      @where
        parent_id: entity.get 'parent_id'
        day_id: entity.get 'day_id'


    tree: (day_id, parent_id = 0, json = false) ->
      entities = @where(day_id: day_id)
      if json
        entities = _.map entities, (entity) -> entity.toJSON()
      flat_tree = _.groupBy entities, (entity) -> if json then entity.parent_id else entity.get('parent_id')
      @_flatTreeToTree(flat_tree, parent_id)

    _flatTreeToTree: (flat_tree, parent_id) ->
      _.map(flat_tree[parent_id], (entity) ->
        entity: entity,
        children: @_flatTreeToTree(flat_tree, entity.id) if flat_tree[entity.id]
      , this)

    eachFromTree: (tree, cb) ->
      _.each tree, (item) =>
        cb(item.entity)
        @eachFromTree(item.children, cb) if item.children

    eachProductFromTree: (cb) ->
      Days.forEach (day) =>
        tree = @tree(day.get('id'))
        @eachFromTree tree, (entity) ->
          cb(entity) if entity.isProduct()

    productsTotals: ->
      products = {}
      @eachProductFromTree (entity) =>
        product_id = entity.get('entity_id')
        if !products[product_id]
          products[product_id] =
            product: entity.getEntityModel()
            entities: []
            weight: 0
        products[product_id].entities.push entity
        products[product_id].weight += entity.get('weight')
      Object.keys(products).map (key) -> products[key]

  ))
)()
