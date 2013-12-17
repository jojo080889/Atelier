$(document).ready ->
  $(".entry-browse-image").click (e) ->
    $("#entry_image").click();
    e.preventDefault();

  $("#entry_image").change ->
    string = $("#entry_image").val()
    filename = string.match(/\\([^\\]*\..*$)/)[1]
    $("#entry-file-name").html(filename)
