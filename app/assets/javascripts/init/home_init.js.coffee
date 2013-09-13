#= require views/calendar_view
#= require views/home_trips_list_view
#= require views/home_filters_view
$ ->
  calendarView = new App.views.CalendarView(start_date: new Date())
  listView = new App.views.HomeTripsListView()
  filtersView = new App.views.HomeFiltersView()

