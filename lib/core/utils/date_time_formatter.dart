import 'package:intl/intl.dart';

abstract final class DateTimeFormatter {
  static String eventTime(DateTime dt) => DateFormat('h:mm a').format(dt);
  static String eventShortDate(DateTime dt) => DateFormat('MMM d').format(dt);
  static String monthAbbr(DateTime dt) =>
      DateFormat('MMM').format(dt).toUpperCase();
  static String dayNumber(DateTime dt) => DateFormat('d').format(dt);
  static String chatTimestamp(DateTime dt) => DateFormat('hh:mm a').format(dt);
  static String eventDetailsFull(DateTime dt) =>
      DateFormat("EEEE, MMMM d, y '•' h:mm a").format(dt);
}
