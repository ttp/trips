//= require jquery.markitup

$ ->
  markitupTextile =
    nameSpace: "textile"
    previewAutoRefresh: false
    onShiftEnter:
      keepDefault: false
      replaceWith: "\n\n"

    markupSet: [
      name: "H1", key: "1", openWith: "h1(!(([![Class]!]))!). ", placeHolder: "Your title here...", className: "btn btn-default btn-sm"
    ,
      name: "H2", key: "2", openWith: "h2(!(([![Class]!]))!). ", placeHolder: "Your title here...", className: "btn btn-default btn-sm"
    ,
      name: "H3", key: "3", openWith: "h3(!(([![Class]!]))!). ", placeHolder: "Your title here...", className: "btn btn-default btn-sm"
    ,
      name: "H4", key: "4", openWith: "h4(!(([![Class]!]))!). ", placeHolder: "Your title here...", className: "btn btn-default btn-sm"
    ,
      name: "H5", key: "5", openWith: "h5(!(([![Class]!]))!). ", placeHolder: "Your title here...", className: "btn btn-default btn-sm"
    ,
      separator: "---------------"
    ,
      name: "", title: "Bold", key: "B", closeWith: "*", openWith: "*", className: "btn btn-default btn-sm action-bold"
    ,
      name: "", key: "I", closeWith: "_", openWith: "_", className: "btn btn-default btn-sm action-italic"
    ,
      name: "", key: "S", closeWith: "-", openWith: "-", className: "btn btn-default btn-sm action-strikethrough"
    ,
      separator: "---------------"
    ,
      name: "", openWith: "(!(* |!|*)!)", className: "btn btn-default btn-sm action-list-ul", multiline: true
    ,
      name: "", openWith: "(!(# |!|#)!)", className: "btn btn-default btn-sm action-list-ol", multiline: true
    ,
      separator: "---------------"
    ,
      name: "", replaceWith: "![![Source:!:http://]!]([![Alternative text]!])!", className: "btn btn-default btn-sm action-picture-o"
    ,
      name: "", openWith: "\"", closeWith: "([![Title]!])\":[![Link:!:http://]!]", placeHolder: "Your text to link here...", className: "btn btn-default btn-sm action-link"
    ,
      separator: "---------------"
    ,
      name: " Preview", call: "preview", className: "btn btn-default btn-sm action-eye"
    ]

  
  actions = ["bold", "italic", "strikethrough", "list-ul", "list-ol", "picture-o", "link", "eye"]

  $("textarea.textile").each ->
    textarea = $(this)
    
    preview = $("<div class='preview well'></div>")
    preview.insertAfter textarea
    preview.hide()

    options = $.extend {}, markitupTextile,
      previewHandler: (text) ->
        if preview.is(':visible')
          textarea.toggle()
          preview.toggle()
        else
          $.ajax
            type: 'POST',
            dataType: 'text',
            global: false,
            url: '/textile/preview',
            data:
              data: text
            success: (response) ->
              preview.html(response)
              textarea.toggle()
              preview.toggle()
        
    textarea.markItUp options
    wrapper = textarea.closest('.markItUp')
    wrapper.find('.markItUpFooter').remove()
    wrapper.find(".markItUpHeader").addClass "btn-toolbar"
    wrapper.find("ul").addClass "btn-group"
    _.each actions, (action) ->
      wrapper.find(".action-" + action + " a").addClass "fa fa-" + action