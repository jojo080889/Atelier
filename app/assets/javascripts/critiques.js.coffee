$(document).ready ->
  window.literallyCanvasInit = literallyCanvasInit

  # This only works in chrome with the --disable-web-security flag on localhost.
  if $(".project-image img").length != 0
    originalImg = new Image()
    originalImg.crossOrigin = "anonymous"
    originalImg.src = $(".project-image img").attr("src")
    originalImg.onload = ->
      originalShape = new LC.ImageShape(0,0, originalImg)
      $(".literally").literallycanvas({
        imageURLPrefix: '/assets/literallycanvas',
        backgroundShapes: [originalShape],
        toolClasses: [LC.PencilWidget, LC.EraserWidget, LC.LineWidget, LC.RectangleWidget, LC.TextWidget, LC.PanWidget],
        onInit: (lc) ->
          window.LCTemp = lc;
          literallyCanvasInit(lc, $(".new_critique"))
      })

literallyCanvasInit = (lc, parent) ->
  $(".literally", parent).hide()
  lc.on("drawingChange", ->
    if lc.numShapes() == 0
      $("#paintover_data", parent).val("none")
      $("#critique_paintover_snapshot", parent).val("")
    else
      $("#paintover_data", parent).val(lc.canvasForExport().toDataURL())
      $("#critique_paintover_snapshot", parent).val(lc.getSnapshotJSON())
  )
