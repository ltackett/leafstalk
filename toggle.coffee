###
Toggle - General-porpose click-to-toggle

From some fine folks at Turing.
Lorin Tackett     [https://github.com/ltackett]
Ali Aslam         [https://github.com/alibilalaslam]
###

$(".toggle").click (e) ->
  e.preventDefault()

  source = $(this)
  target = $(this).attr "rel"
  $target = $("##{target}")
  wrapper = $(this).closest("#wrapper")

  source.css("z-index", "90").addClass("active")

  # Toggle the target on/off
  $target.toggle().css("z-index", "1000")

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