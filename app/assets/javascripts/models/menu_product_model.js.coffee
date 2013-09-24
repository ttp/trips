(->
  _.namespace "App.models"
  App.models.MenuProductModel = Backbone.Model.extend(
    info: ->
      calories: @get('calories')
      proteins: @get('proteins')
      fats: @get('fats')
      carbohydrates: @get('carbohydrates')

    infoText: ->
      _.map @info(), (value, field)->
        I18n.t('menu.' + field) + ': ' + value
  )
)()
