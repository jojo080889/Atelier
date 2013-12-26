$(document).ready ->
  window.literallyCanvasInit = literallyCanvasInit

  # This only works in chrome with the --disable-web-security flag.
  if $(".entry-image img").length != 0
    originalImg = new Image()
    originalImg.src = $(".entry-image img").attr("src")
    originalImg.crossOrigin = "use-credentials"
    originalImg.onload = ->
      originalShape = new LC.ImageShape(0,0, originalImg)
      $(".literally").literallycanvas({
        imageURLPrefix: '/assets/literallycanvas',
        backgroundShapes: [originalShape],
        toolClasses: [LC.PencilWidget, LC.EraserWidget, LC.LineWidget, LC.RectangleWidget, LC.TextWidget, LC.PanWidget],
        onInit: (lc) ->
          literallyCanvasInit(lc)
      })

literallyCanvasInit = (lc) ->
  $(".literally").hide()
  lc.on("drawingChange", ->
    $("#paintover_data").val(lc.canvasForExport().toDataURL())
    $("#critique_paintover_snapshot").val(lc.getSnapshotJSON())
  )
  lc.on("clear", ->
    $("#paintover_data").val("none")
    $("#critique_paintover_snapshot").val("")
  )

