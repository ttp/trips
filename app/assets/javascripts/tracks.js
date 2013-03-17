//= require libs/date
//= require libs/daterangepicker

$(function () {
    $('.nav-tabs a').click(function (e) {
        e.preventDefault();
        $(this).tab('show');
    });
});