import 'ui_extention.dart';
import 'package:intl/intl.dart';
// import "package:timeago/timeago.dart" as time_ago;

class DateClass {
  late DateTime dateTime;
  late String day;
  late String date;
  late String fullFormattedDate;

  DateClass({
    required this.dateTime,
    required this.day,
    required this.date,
    required this.fullFormattedDate,
  });
}

extension DateExtension on DateTime {
  static final DateTime today = DateTime.now();
  static final DateTime yesterDay = 1.pDate;

  static final DateTime tomorrow = 1.fDate;

  String get dateDayFormat => DateFormat.d().format(this);

  ///* Return Formatted time as `String` [25 July]
  String get dateMonthFormat => DateFormat.MMMMd().format(this);

  ///* Return Formatted time as `String` [25 Jul]
  String get dateMonthShortFormat => DateFormat.MMMd().format(this);

  ///* Return Formatted Day, Month, Year name as `String` [19 July 2022]
  String get dateMonthYearFormat => DateFormat.yMMMd().format(this);

  ///* Return Formatted time as `String` [25 Jul]
  String get dayDateMonthShortFormat => DateFormat.MMMMEEEEd().format(this);

  ///* Return Formatted Day [Sunday]
  String get dayFormat => DateFormat.EEEE().format(this);

  ///* Return Formatted Day, Month, Year name as `String` [Sunday, 19 July 2022]
  String get dayMonthYearFormat => DateFormat.yMMMEd().format(this);

  ///* Return ```true``` if provided date is in same month of the today
  bool get isCurrentMonth => today.month == month && today.year == year;

  ///* Return ```true``` if provided date is of this week
  bool get isCurrentWeek => today.difference(this).inDays <= 7;

  ///* Return ```true``` if provided date is in same year of the today
  bool get isCurrentYear => today.year == year;

  ///* Return ```true``` if provided date is of yesterday
  bool get isTomorrow => tomorrow.day == day && tomorrow.month == month && tomorrow.year == year;

  ///* Return ```true``` if provided date is today
  // bool get isToday =>
  //     today.day == day && today.month == month && today.year == year;

  ///* Return ```true``` if provided date is of yesterday
  bool get isYesterday => yesterDay.day == day && yesterDay.month == month && yesterDay.year == year;

  ///* Return Formatted Month name as `String` [July]
  String get monthName => DateFormat.MMMM().format(this);

  ///* Return Formatted Month, Year name as `String` [July 2022]
  String get monthYearFormat => DateFormat.yMMM().format(this);

  String get monthYearFormatEnglish => DateFormat.yMMM('en').format(this);

  ///* Return Formatted Day, Month, Year name as `String` [01-03-2022]
  String get shortDateMonthYearFormat => DateFormat(
        "d-MM-y",
      ).format(this);

  ///* Return Formatted Day, Month, Year name as `String` [03/2022]
  String get shortMonthYearFormat => DateFormat(
        "MM/yy",
      ).format(this);

  String get utcFormat => DateFormat(
        "yyyy-MM-dd'T'HH:mm:ss.SSS",
      ).format(this);

  String get utcToLocalFormat => DateFormat('dd MMM yyyy hh:mm a', 'en_US').format(
        toLocal(),
      );

  ///* Return Formatted Day, Month, Year name as `String` [03/10]
  String get shortMYFormat => DateFormat(
        "dd/MM",
      ).format(this);

  // ///* Return Formatted Time ago [1 minute ago]
  // String get timeAgoFormat => time_ago.format(this);

  ///* Return Formatted Day, Month, Year name as `String` [01:30 am, Sunday, 19 July 2022]
  String get timedayMonthYearFormat => DateFormat(
        null,
      ).add_jm().add_yMMMMd().format(this);

  ///* Return Formatted time as `String` [12:05 PM]
  String get timeFormat => DateFormat.jm().format(this);

  //12:22:00 AM get string in this format
  String get timeFormat12 => DateFormat.jms().format(this);

  ///* Return Formatted time as `String` [12:05 PM]
  String get dateAndTimeFormat => "${DateFormat('y-M-d').format(this)} (${DateFormat.jm().format(this)})";

  // ///* Return week of the month
  // Week get week {
  //   int week = 1;
  //   if (day % 7 == 0) {
  //     week = day ~/ 7;
  //   } else if (day > 28) {
  //     week = 4;
  //   } else {
  //     week = (day / 7).ceil();
  //   }
  //   return Week.values[week - 1];
  // }

  ///* Return week of the month
  int get weekOfMonth {
    if (day % 7 == 0) {
      return day ~/ 7;
    } else if (day > 28) {
      return 4;
    } else {
      return (day / 7).ceil();
    }
  }
}

extension DateHelpers on DateTime {
  bool isInFuture(DateTime date) {
    final now = DateTime.now();

    if (date.isAfter(now)) {
      return true;
    } else {
      return false;
    }
  }

  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day && yesterday.month == month && yesterday.year == year;
  }
}
