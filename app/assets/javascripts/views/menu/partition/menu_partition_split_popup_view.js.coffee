#= require models/menu_partition_auto_splitter

_.namespace "App.views"
(->
  App.views.MenuPartitionSplitPopupView = Backbone.View.extend(
    el: '#splitPopup'
    events:
      "change input": "changeWeightRank",
      "click button.cancel": "hide",
      "click button.split": "autoSplit"

    initialize: (options) ->
      @porters = App.collections.MenuPartitionPorterCollection

    render: ->
      html = JST["templates/food/partition/porters_weight_ranks"](porters: @porters.models)
      @$el.find('.modal-body').html(html)

    show: ->
      @$el.modal('show')

    hide: ->
      @$el.modal('hide')

    changeWeightRank: (e) ->
      input = $(e.target)
      porter = @porters.get(input.data('porter-id'))
      porter.set('weight_rank', parseInt($(e.target).val()))

    autoSplit: (e) ->
      splitter = new App.models.MenuPartitionAutoSplitter
      splitter.split()
      @hide()

  )
)()