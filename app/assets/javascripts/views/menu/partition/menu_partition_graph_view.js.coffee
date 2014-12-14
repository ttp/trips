#= require highcharts-custom
#= require collections/menu_partition_porter_collection
#= require collections/menu_partition_porter_day_entity_collection
#= require collections/menu_day_collection

_.namespace "App.views"
(->
  days = App.collections.MenuDayCollection
  App.views.MenuPartitionGraphView = Backbone.View.extend(
    el: '#weightGraph'
    initialize: (options) ->
      @options = options
      @porters = App.collections.MenuPartitionPorterCollection
      @porter_entities = App.collections.MenuPartitionPorterDayEntityCollection
      @render()
      @bindEvents()

    render: ->
      @$el.highcharts @graphOptions()

    bindEvents: ->
      renderData = _.throttle $.proxy(@render, this), 100
      @porter_entities.on 'add', renderData
      @porter_entities.on 'remove', renderData
      @porters.on 'add remove', renderData

    graphOptions: ->
      title: { text: I18n.t('menu.partitions.weight_graph') }
      chart: { animation: false }
      xAxis: { categories: @labels() }
      yAxis: { min: 0, title: { text: @graphYAxisTitle() } }
      tooltip:
        valueSuffix: I18n.t('menu.g')
        animation: false
        positioner: ->
          { x: 10, y: 10 }
      legend: { layout: 'vertical', align: 'right', verticalAlign: 'middle', borderWidth: 0 }
      series: @series()
      plotOptions: { line: { animation: false } }

    graphYAxisTitle: ->
      "#{I18n.t('menu.weight')} (#{I18n.t('menu.g')})"

    labels: ->
      [1..(days.length + 1)]

    series: ->
      _.map(@porters.models, (porter) ->
        name: porter.get('name'),
        data: @porterData(porter)
      , this)

    porterData: (porter) ->
      data = [porter.total_weight()]
      days.each (day, i) ->
        data.push(data[i] - porter.dayWeight(day))
      data
  )
)()