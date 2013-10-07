#= require views/trip_users_view
#= require views/trip_comments_view
$ ->
  users_view = new App.views.TripUsersView()
  comments_view = new App.views.TripCommentsView()
  $('button.menu').click ->
    $(this).find('i').toggleClass('glyphicon-chevron-down glyphicon-chevron-up')
