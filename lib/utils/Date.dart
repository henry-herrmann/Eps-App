

getDate(date) {
  var day = date.weekday == 1 ? "Mo"
      : date.weekday == 2 ? "Di"
      : date.weekday == 3 ? "Mi"
      : date.weekday == 4 ? "Do"
      : date.weekday == 5 ? "Fr"
      : date.weekday == 2 ? "Sa"
      : date.weekday == 2 ? "So"
      : "-";

  var month = date.month == 1 ? "Januar"
      : date.month == 2 ? "Februar"
      : date.month == 3 ? "März"
      : date.month == 4 ? "April"
      : date.month == 5 ? "Mai"
      : date.month == 6 ? "Juni"
      : date.month == 7 ? "Juli"
      : date.month == 8 ? "August"
      : date.month == 9 ? "September"
      : date.month == 10 ? "Oktober"
      : date.month == 11 ? "November"
      : date.month == 12 ? "Dezember"
      : "Januar";
}