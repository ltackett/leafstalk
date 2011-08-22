###
Overlay - Coffeescript wrapper for jQuery UI Dialog

From some fine folks at Turing.
Ali Aslam         [https://github.com/alibilalaslam]
Lorin Tackett     [https://github.com/ltackett]
Julian Coutu      [https://github.com/jcoutu]
Stephen Judkins   [https://github.com/stephenjudkins]
###

@Overlay = {
  init: ->
    @defaultContainer = $("#overlay")

  create: (options) ->
    self = @

    @container = options.container or @defaultContainer
    delete options.container

    content = options.content
    delete options.content

    noCloseButton = options.noCloseButton
    delete options.noCloseButton

    onOpen = options.open
    delete options.open

    onClose = options.close
    delete options.close

    containerId = @container.attr "id"

    defaults = {
      modal: true
      draggable: false
      resizable: false
      closeOnEscape: false
      width: 630
      position: ['center', 82] if $("html").hasClass "embedded"

      open: (event, ui) ->
        # Prevent user from closing the dialog if corresponding custom option is set
        if noCloseButton
          $("#ui-dialog-title-#{containerId}").next('.ui-dialog-titlebar-close').remove()

        # prevent document scrollbars from being disabled by overlay
        window.setTimeout((-> $(document).unbind('mousedown.dialog-overlay').unbind('mouseup.dialog-overlay')), 100)

        self.container.find("select").selectBox()

        onOpen(event, ui) if onOpen

      close: (event, ui) ->
        self.container.find("select").selectBox("destroy")

        onClose(event, ui) if onClose

    }
    @container.html(content).dialog $.extend({}, defaults, options)

  replace_content: (content) ->
    @container.find("select").selectBox("destroy")
    @container.html(content)
    @container.find("select").selectBox()

    @container.dialog("option", "position", "center") unless $("html").hasClass "embedded"
    @container.trigger "dialogcontentreplaced"
    

  remove: () ->
    @container?.dialog "close"
  
  isOpen: () ->
    @container?.dialog("isOpen") is true
}

$ ->
  Overlay.init()

  $("a.cancel").live "click", (e) ->
    e.preventDefault()
    if(Overlay.isOpen())
      Overlay.remove()
    else
      history.go(-1)

  $("a[rel*=overlay]").live "click", (e) ->
    e.preventDefault()
    $("#notice").html ""

    link = $ @
    if link.attr "data-container"
      container = $ "<div id='#{link.attr('data-container')}' />"
    else
      container = $ link.attr("rel")

    if container.length > 0
      Overlay.create {
        title: link.text()
        content: $("#loading-screen")
        container: container
        noCloseButton: !!link.attr("data-overlay-no-close-button")
      }
      $("#loading-screen").show()
  
      $.ajax
        url: link.attr("href")
        type: link.attr("data-overlay-http-method") or "GET"
        success: (response) ->
          Overlay.replace_content(response)
          $("#loading-screen").hide()

  if document.location.hash.indexOf("#overlay-") == 0
    name = document.location.hash.split("#overlay-")[1]
    $("a[rel*=overlay]").each ->
      $(@).click() if $(@).attr('data-container') == name
        

  $("#overlay form[rel='#close-overlay-on-submit']").live "submit", (e) ->
    e.preventDefault()
    $(this).ajaxSubmit({success: -> Overlay.remove()})

