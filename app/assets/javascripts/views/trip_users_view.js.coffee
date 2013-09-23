_.namespace "App.views"
(->
  App.views.TripUsersView = Backbone.View.extend(
    el: "#trip_users"
    events:
      "click a.leave": "leave"
      "click a.approve": "approve"
      "click a.decline": "declineConfirm"
      "click #decline_reason .btn-primary": "decline"

    toggleAvailablePlaces: (availablePlaces) ->
      @$el.find(".available-places .places").text availablePlaces
      @$el.find(".available-places").toggle availablePlaces > 0
      @$el.find(".no-available-places").toggle availablePlaces is 0
      @toggleNoUsers()

    toggleNoUsers: ->
      @$el.find(".no-users").toggle @$el.find(".trip-users .user").length is 0

    leave: (e) ->
      e.preventDefault()
      el = $(e.target)
      return  if el.hasClass("in-progress")
      return  unless confirm(I18n.t("trip.cancel_request") + "?")
      el.addClass "in-progress"
      $.ajax
        url: el.attr("href")
        type: "POST"
        data: App.getTokenHash()
        dataType: "json"
        context: this
        success: (data) ->
          if data.status is "ok"
            el.closest(".user").remove()
            @toggleAvailablePlaces data.available_places
          el.removeClass "in-progress"


    approve: (e) ->
      e.preventDefault()
      el = $(e.target)
      return  if el.hasClass("in-progress")
      el.addClass "in-progress"
      $.ajax
        url: el.attr("href")
        type: "POST"
        data: App.getTokenHash()
        dataType: "json"
        context: this
        success: (data) ->
          if data.status is "ok"
            @$el.find(".trip-users").append el.closest(".user")
            @toggleAvailablePlaces data.available_places
            el.remove()


    declineConfirm: (e) ->
      e.preventDefault()
      el = $(e.target)
      return  if el.hasClass("in-progress")
      @_declineEl = el
      username = el.closest(".user").find(".username").text()
      modal = $("#decline_reason")
      modal.find(".username").text username
      modal.modal "show"
      modal.find("textarea").val ""

    decline: (e) ->
      e.preventDefault()
      modal = $("#decline_reason")
      @_declineEl.addClass "in-progress"
      postData = _.extend(App.getTokenHash(),
        message: modal.find("textarea").val()
      )
      $.ajax
        url: @_declineEl.attr("href")
        type: "POST"
        data: postData
        dataType: "json"
        context: this
        success: (data) ->
          if data.status is "ok"
            @_declineEl.closest(".user").remove()
            @toggleAvailablePlaces data.available_places
          @_declineEl.removeClass "in-progress"

      modal.modal "hide"
  )
)()
