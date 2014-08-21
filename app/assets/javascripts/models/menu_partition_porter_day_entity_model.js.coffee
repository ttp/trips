_.namespace "App.models"
(->
  App.models.MenuPartitionPorterDayEntityModel = Backbone.Model.extend(
    initialize: ->
      unless @id
        @set "id", @cid
        @set "new", 1

    porter: ->
      App.collections.MenuPartitionPorterCollection.get(@get('partition_porter_id'))
  )
)()
