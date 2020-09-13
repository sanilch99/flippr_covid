String convertDate(DateTime tm) {
  String day;
  String month;
  String year=tm.year.toString();
  switch (tm.month) {
    case 1:
      month = "01";
      break;
    case 2:
      month = "02";
      break;
    case 3:
      month = "03";
      break;
    case 4:
      month = "04";
      break;
    case 5:
      month = "05";
      break;
    case 6:
      month = "06";
      break;
    case 7:
      month = "07";
      break;
    case 8:
      month = "08";
      break;
    case 9:
      month = "09";
      break;
    default:
      month = tm.month.toString();
      break;
  }

  switch (tm.day) {
    case 1:
      day = "01";
      break;
    case 2:
      day = "02";
      break;
    case 3:
      day = "03";
      break;
    case 4:
      day = "04";
      break;
    case 5:
      day = "05";
      break;
    case 6:
      day = "06";
      break;
    case 7:
      day = "07";
      break;
    case 8:
      day = "08";
      break;
    case 9:
      day = "09";
      break;
    default:
      day = tm.day.toString();
      break;
  }
  return "$day-$month-$year";
}

String convertDateDiff(DateTime tm) {
  String day;
  String month;
  String year=tm.year.toString();
  switch (tm.month) {
    case 1:
      month = "01";
      break;
    case 2:
      month = "02";
      break;
    case 3:
      month = "03";
      break;
    case 4:
      month = "04";
      break;
    case 5:
      month = "05";
      break;
    case 6:
      month = "06";
      break;
    case 7:
      month = "07";
      break;
    case 8:
      month = "08";
      break;
    case 9:
      month = "09";
      break;
    default:
      month = tm.month.toString();
      break;
  }

  switch (tm.day) {
    case 1:
      day = "01";
      break;
    case 2:
      day = "02";
      break;
    case 3:
      day = "03";
      break;
    case 4:
      day = "04";
      break;
    case 5:
      day = "05";
      break;
    case 6:
      day = "06";
      break;
    case 7:
      day = "07";
      break;
    case 8:
      day = "08";
      break;
    case 9:
      day = "09";
      break;
    default:
      day = tm.day.toString();
      break;
  }
  return "$year-$month-$day";
}
//02-09-2020
DateTime convertString(String s){
  int year=int.parse(s.substring(6));
  int month=int.parse(s.substring(3,5));
  int day=int.parse(s.substring(0,2));
  DateTime td=DateTime.utc(year,month,day);
  return td;
}