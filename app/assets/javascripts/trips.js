//= require moment
//= require daterangepicker

$(function () {
    $('#trip_dates_range').daterangepicker({
        format: 'DD-MM-YYYY',
        locale: {
            applyLabel: 'OK',
            clearLabel: "Очистити",
            fromLabel: 'Початок',
            toLabel: 'Кінець',
            weekLabel: 'W',
            customRangeLabel: 'Custom Range',
            daysOfWeek: I18n.t('date.abbr_day_names'),
            monthNames: I18n.t('date.month_names').slice(1),
            firstDay: 1
        }
    });
});