### ========================================================================= #
lsOverlay - Coffeescript wrapper for jQuery UI Dialog

From some fine folks at Turing.
Ali Aslam         [https://github.com/alibilalaslam]
Lorin Tackett     [https://github.com/ltackett]
Julian Coutu      [https://github.com/jcoutu]
Stephen Judkins   [https://github.com/stephenjudkins]

Required libraries:
jQuery UI:    http://jqueryui.com/
jQuery Form:  http://jquery.malsup.com/form/
# ========================================================================= ###

@lsOverlay = {
  init: ->
    fullPageOverlayDiv = $(".full-page-overlay")
    if fullPageOverlayDiv.length > 0
      @container = fullPageOverlayDiv
      @isFullPage = true
      @container.addClass("overlay")
    else
      @defaultContainer = $("#overlay")
      if @defaultContainer.length == 0
        $("body").append(@container = @defaultContainer = $("<div id='overlay></div>"))

  create: (options) ->
    self = @

    @container = options.container or @defaultContainer
    delete options.container

    @container.addClass("overlay")

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

        onOpen(event, ui) if onOpen

      close: (event, ui) ->
        onClose(event, ui) if onClose

    }
    @container.html(content).dialog $.extend({}, defaults, options)

  replaceContent: (content) ->
    @container.find("select").selectBox("destroy")
    @container.html(content)
    @container.find("select").selectBox()

    @container.dialog("option", "position", "center") unless $("html").hasClass "embedded"
    @container.trigger "dialogcontentreplaced"


  remove: () ->
    @container?.dialog "close"

  isOpen: () ->
    @isFullPage or @container?.dialog("isOpen") is true
}

$ ->
  lsOverlay.init()

  $("a.cancel").live "click", (e) ->
    e.preventDefault()
    if embeddedLink = $(@).attr("data_device_embedded")
      window.location = embeddedLink
    else
      if(lsOverlay.isOpen())
        lsOverlay.remove()
      else
        history.go(-1)

  $("a[rel*=overlay]").live "click", (e) ->
    e.preventDefault()

    link = $ @
    if containerId = link.attr "data-container"
      container = if $("##{containerId}").length then $("##{containerId}") else $("<div id='#{containerId}' />")
    else
      container = $ link.attr("rel")

    if container.length > 0
      lsOverlay.create {
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
          lsOverlay.replaceContent(response)
          $("#loading-screen").hide()

  if document.location.hash.indexOf("#overlay-") == 0
    name = document.location.hash.split("#overlay-")[1]
    $("a[rel*=overlay]").each ->
      $(@).click() if $(@).attr('data-container') == name


  $("#overlay form[rel='#close-overlay-on-submit']").live "submit", (e) ->
    e.preventDefault()
    $(this).ajaxSubmit(success: -> lsOverlay.remove())

  $("[rel=open-in-overlay]").live "click", (e) ->
    e.preventDefault()
    $.get $(@).attr("href"), (response) ->
      lsOverlay.replaceContent response

  $(".overlay form").live
    submit: (event) ->
      event.preventDefault()
      form = $(@)
      form.ajaxSubmit
        success: (response, statusText, xhr, $form) -> form.trigger("overlaySuccess", response)
        error: (response) -> form.trigger("overlayError", response)
    overlaySuccess: (event, response) ->
      if lsOverlay.isFullPage
        lsOverlay.replaceContent(response)
      else
        lsOverlay.remove()
    overlayError: (event, response) ->
      $("#error-explanation").remove()
      $(@).prepend(response.responseText)
