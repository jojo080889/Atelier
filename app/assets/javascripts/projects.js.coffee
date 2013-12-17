# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  sortProjectsHandler()
  window.sortProjectsHandler = sortProjectsHandler

sortProjectsHandler = (element = "all") ->
  element = $(".sort-projects #order_by") if (element == "all")
  element.change (e) ->
    $(this).parents(".sort-projects").submit()
    e.preventDefault()
