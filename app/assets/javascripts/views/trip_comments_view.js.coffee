_.namespace "App.views"
(->
  App.views.TripCommentsView = Backbone.View.extend(
    el: "#trip_comments"
    events:
      "click a.add-comment": "showAddForm"
      "click button.cancel-add-comment": "hideAddForm"
      "submit form.add-comment": "addComment"
      "click a.edit": "showEditForm"
      "click button.cancel-edit-comment": "hideEditForm"
      "submit form.update-comment": "updateComment"
      "click a.remove": "remove"

    showAddForm: (e) ->
      e.preventDefault()
      @$el.find("form.add-comment").toggle()

    hideAddForm: (e) ->
      e.preventDefault()
      @$el.find("form.add-comment").hide()

    addComment: (e) ->
      e.preventDefault()
      form = $(e.target)
      btnPrimary = form.find(".btn-primary")
      btnPrimary.addClass "disabled"
      $.ajax
        url: form.attr("action")
        type: "POST"
        data: form.serialize()
        dataType: "json"
        context: this
        success: (data, status) ->
          @$el.find(".comments").append $(data.bubble)
          @$el.find(".no-comments").hide()
          btnPrimary.removeClass "disabled"
          form[0].reset()
          form.hide()

        error: (data, status) ->
          btnPrimary.removeClass "disabled"


    showEditForm: (e) ->
      e.preventDefault()
      commentEl = $(e.target).closest(".comment")
      commentEl.find("form").show()
      commentEl.find(".message").hide()

    hideEditForm: (e) ->
      commentEl = $(e.target).closest(".comment")
      commentEl.find("form").hide()
      commentEl.find(".message").show()
      false

    updateComment: (e) ->
      e.preventDefault()
      form = $(e.target)
      btnPrimary = form.find(".btn-primary")
      btnPrimary.addClass "disabled"
      $.ajax
        url: form.attr("action")
        type: "POST"
        data: form.serialize()
        dataType: "json"
        context: this
        success: (data, status) ->
          form.closest(".comment").find(".message").html data.message
          btnPrimary.removeClass "disabled"
          @hideEditForm e

        error: (data, status) ->
          btnPrimary.removeClass "disabled"


    remove: (e) ->
      e.preventDefault()
      el = $(e.target)
      return  unless confirm(I18n.t("comments.remove_confirm"))
      el.addClass "disabled"
      $.ajax
        url: el.attr("href")
        type: "POST"
        data: $.extend(
          _method: "delete"
        , App.getTokenHash())
        dataType: "json"
        success: ->
          el.closest(".comment").remove()

        error: ->
          el.removeClass "disabled"

  )
)()
