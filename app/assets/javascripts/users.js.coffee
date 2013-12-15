$(document).ready ->
  $("#vis_birthday").datepicker({
    changeYear: true,
    changeMonth: true,
    yearRange: "1900:" + (new Date).getFullYear(),
    altFormat: "yy-mm-dd 00:00:00 UTC",
    altField: "#user_birthday"})
  fillInBirthdayText()

fillInBirthdayText = ->
  birthday = $("#user_birthday").val()
  if birthday != "" && birthday?
    formattedBday = $.datepicker.formatDate("mm/dd/yy", $.datepicker.parseDate("yy-mm-dd 00:00:00 UTC", birthday))
    $("#vis_birthday").val(formattedBday)
