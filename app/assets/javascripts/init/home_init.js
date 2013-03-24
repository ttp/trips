//= require views/calendar_view
//= require views/home_filters_view

$(function () {
    var calendarView = new App.views.CalendarView({
        start_date: new Date()
    });
    var filtersView = new App.views.HomeFiltersView({});

    $('a.next').click(function () {
        var height = $('#calendar .row-fluid:eq(2)').height();
        $('#calendar .row-fluid:eq(1)').animate({'margin-top': -height + 'px'}, 500);
        $('#calendar .row-fluid:eq(3)').slideDown(500);
    });

    $('a.prev').click(function () {
        $('#calendar .row-fluid:eq(1)').animate({'margin-top': 0 + 'px'}, 500);
        $('#calendar .row-fluid:eq(3)').slideUp(500);
    });
});