import 'package:intl/intl.dart';

class Time {
  static String timeStringToLocalTimeString(String time) {
    return DateFormat("yyyy-MM-dd hh:mm")
        .format(DateTime.parse(time).toLocal())
        .toString();
  }

  static String timeToLocalTimeString(DateTime time) {
    return DateFormat("yyyy-MM-dd hh:mm").format(time.toLocal()).toString();
  }

  static String timeNowToLocalTimeString() {
    return DateFormat("yyyy-MM-dd hh:mm")
        .format(DateTime.now().toLocal())
        .toString();
  }
}
