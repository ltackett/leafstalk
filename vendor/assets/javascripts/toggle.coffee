### ========================================================================= #
lsToggle - General-purpose click-to-toggle

From some fine folks at Turing.
Lorin Tackett     [https://github.com/ltackett]
Ali Aslam         [https://github.com/alibilalaslam]
# ========================================================================= ###

### CoffeeScript already wraps everything
in an anonymous function, so this is safe. ###
$ = jQuery

$.fn.lsToggle = (options) ->
  
  defaults =
    speed:        "fast"
    target:       false
    sourceZ:      90
    targetZ:      1000
    clickOverlay: false
  options = $.extend defaults, options
  
  # Make chainable, and iterate through each jQuery object passed in.
  return @.each ->

    $(@).click (e) ->
      e.preventDefault()
      
      source = $(@)

      # rel attribute is a selector
      if source.attr("rel")
        targetSelector = source.attr("rel")

        # rev attribute is selector for parent elements, and rel attribute
        # becomes a selector for child elements of that parent
        if source.attr("rev")
          targetSelector = source.closest(source.attr("rev")).find(source.attr("rel"))

      # otherwise, just use the ID of the page anchor.
      else
        targetSelector = source.attr "href"
      
      # If we've passed in an optional target, and that target is a jQuery
      # object, use that as $target, otherwise use the options.target we built.
      if options.target instanceof jQuery
        $target = options.target
      else
        if targetSelector instanceof jQuery
          $target = $(targetSelector)
        else
          $target = $("#{targetSelector}")

      source.css("z-index", options.sourceZ).addClass("active")
      $target.toggle(options.speed).css("z-index", options.targetZ)

      # Click Overlay
      if options.clickOverlay
        $target.trigger("ClickOverlay.afterOpen") if $target.is(":visible")

        # If there's already a click overlay, remove it. Otherwise add one.
        if $("#click_overlay").length > 0
          $("#click_overlay").remove()
        else
          $('<div id="click_overlay" />').
            appendTo("body").
            data("target", target). # we may need to know what target spawned the overlay later
            css("z-index", "99").
            css("width", $("body").outerWidth()).
            css("height", $("body").outerHeight())