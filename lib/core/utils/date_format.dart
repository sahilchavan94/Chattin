import 'package:intl/intl.dart';

class DateFormatters {
  static String formatDateWithDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String formatDateWithDay(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  static String formatDateWithBothDateAndDay(DateTime dateTime) {
    return "${DateFormat('dd MMM yyyy').format(dateTime)} ${DateFormat.jm().format(dateTime)}";
  }

  static String formatDateWithBothDateAndDayInverse(DateTime dateTime) {
    return "${DateFormat.jm().format(dateTime)} ${DateFormat('dd MMM yyyy').format(dateTime)} ";
  }
}
