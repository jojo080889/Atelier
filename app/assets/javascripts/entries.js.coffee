$(document).ready ->
  $(".entry-browse-image").click (e) ->
    $("#entry_image").click();
    e.preventDefault();

  $("#entry_image").change ->
    $("#entry-file-name").html($("#entry_image").val())
