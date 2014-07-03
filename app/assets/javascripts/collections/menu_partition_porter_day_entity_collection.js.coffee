#= require models/menu_partition_porter_day_entity_model
#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection

_.namespace "App.collections"
(->
  App.collections.MenuPartitionPorterDayEntityCollection = new (Backbone.Collection.extend(
    model: App.models.MenuPartitionPorterDayEntityModel

    total_weight: ->

  ))
)()
