//= require views/trip_users_view

$(function () {
    var users_view = new App.views.TripUsersView();

    $('#trip_comments a.add-comment').click(function () {
        $('#trip_comments form').toggle();
        return false;
    });
});