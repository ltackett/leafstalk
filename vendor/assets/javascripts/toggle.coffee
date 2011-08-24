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
      if source.attr("rel") then  target = source.attr "rel"
      else                        target = source.attr "href"
      if (options.target instanceof jQuery) then  $target = options.target
      else                                        $target = $("#{target}")

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