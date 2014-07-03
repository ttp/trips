#= require views/menu/partition/menu_partition_porter_view
#= require collections/menu_partition_porter_collection
#= require collections/menu_partition_porter_day_entity_collection

_.namespace "App.views"
(->
  App.views.MenuPartitionPortersListView = Backbone.View.extend(
    el: "#partition_porters"
    events:
      "click button.add": "createPorter"

    initialize: (options) ->
      @porters = App.collections.MenuPartitionPorterCollection

    render: ->
      @porters.each (porter) ->
        @renderPorter(porter)

    renderPorter: (porter) ->
      $body = @$el.find('.body')
      view = new App.views.MenuPartitionPorterView
        renderTo: $body
        model: porter
        days_tabs: $('#menu .nav-tabs')

    createPorter: (e) ->
      e.preventDefault()
      porter = new App.models.MenuPartitionPorterModel
        position: @porters.length + 1
      @porters.add porter
      @renderPorter(porter)

    updateData: ->

    updateName: ->
  )
)()