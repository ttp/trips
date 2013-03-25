//= require views/calendar_view
//= require views/home_filters_view

$(function () {
    var calendarView = new App.views.CalendarView({
        start_date: new Date()
    });
    var filtersView = new App.views.HomeFiltersView({});
});