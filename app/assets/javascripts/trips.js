//= require libs/date
//= require libs/daterangepicker

$(function () {
    $('#trip_dates_range').daterangepicker({
        format: 'dd.MM.yyyy',
        locale: {
            applyLabel: 'OK',
            clearLabel: "Очистити",
            fromLabel: 'Початок',
            toLabel: 'Кінець',
            weekLabel: 'W',
            customRangeLabel: 'Custom Range',
            daysOfWeek: ['Нд.', 'Пн.', 'Вт.', 'Ср.', 'Чт.', 'Пт.', 'Сб.'],
            monthNames: Date.CultureInfo.monthNames,
            firstDay: 1
        }
    });
});