//= require views/calendar_view
//= require views/home_trips_list_view

$(function () {
    var calendarView = new App.views.CalendarView({
        start_date: new Date()
    });
});