# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  sortProjectsHandler()
  window.sortProjectsHandler = sortProjectsHandler

  $(".project-browse-image").click (e) ->
    $("#project_image").click();
    e.preventDefault();

  $("#project_image").change ->
    string = $("#project_image").val()
    if string.match(/\\([^\\]*\..*$)/)
      filename = string.match(/\\([^\\]*\..*$)/)[1]
    else
      filename = string
    $("#project-file-name").html(filename)

sortProjectsHandler = (element = "all") ->
  element = $(".sort-projects #order_by") if (element == "all")
  element.change (e) ->
    $(this).parents(".sort-projects").submit()
    e.preventDefault()
