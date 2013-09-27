_.namespace "App.models"
(->
  App.models.MenuDayModel = Backbone.Model.extend(
    defaults:
      coverage: 1

    validation:
      rate: [
        required: true
        msg: 'menu.validation.required'
      ,
        range: [0, 1]
        msg: "menu.validation.day_rate"
      ]

    initialize: ->
      unless @id
        @set "id", @cid
        @set "new", 1
      @set "rate", parseFloat(@get("coverage"))

    num: (change_by) ->
      @set('num', @get('num') + change_by)

    summary: ->
      entities = App.collections.MenuDayEntityCollection.where(day_id: @id, entity_type: 3)
      _.reduce(entities, (result, entity) ->
        result.weight += entity.get('weight')
        product = entity.getEntityModel()
        _.each ['calories', 'proteins', 'fats', 'carbohydrates'], (field) ->
          result[field] += entity.get('weight') * product.get(field) / 100
        result
      , {weight: 0, calories: 0, proteins: 0, fats: 0, carbohydrates: 0})
  )
)()
