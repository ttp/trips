_.namespace "App.models"
(->
  App.models.TripModel = Backbone.Model.extend(
    startDateText: ->
      @dateText @get("start_date")

    endDateText: ->
      @dateText @get("end_date")

    dateText: (date) ->
      date = new Date(date)
      date.getDate() + " " + I18n.t("date.date_month_names")[date.getMonth() + 1] + " " + date.getFullYear()

    datesRangeText: ->
      start_date = new Date(@get("start_date"))
      end_date = new Date(@get("end_date"))
      start_date_items = @startDateText().split(" ")
      if start_date.getFullYear() is end_date.getFullYear()
        start_date_items.pop()
        start_date_items.pop()  if start_date.getMonth() is end_date.getMonth()
      start_date_items.join(" ") + " - " + @endDateText()
  )
)()
