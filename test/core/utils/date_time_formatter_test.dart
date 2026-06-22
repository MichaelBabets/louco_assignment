import 'package:flutter_test/flutter_test.dart';
import 'package:louco_assignment/core/utils/date_time_formatter.dart';

void main() {
  final dt = DateTime(2025, 7, 25, 22, 0); // Friday, July 25 2025 10:00 PM

  group('DateTimeFormatter', () {
    test('eventTime formats as h:mm a', () {
      expect(DateTimeFormatter.eventTime(dt), '10:00 PM');
    });

    test('eventTime formats minutes correctly', () {
      final dtWithMinutes = DateTime(2025, 7, 25, 9, 30);
      expect(DateTimeFormatter.eventTime(dtWithMinutes), '9:30 AM');
    });

    test('monthAbbr returns uppercased month abbreviation', () {
      expect(DateTimeFormatter.monthAbbr(dt), 'JUL');
    });

    test('dayNumber returns day of month as string', () {
      expect(DateTimeFormatter.dayNumber(dt), '25');
    });

    test('chatTimestamp formats as hh:mm a with leading zero', () {
      final morning = DateTime(2025, 7, 25, 7, 14);
      expect(DateTimeFormatter.chatTimestamp(morning), '07:14 AM');
    });

    test('eventDetailsFull formats as full weekday date and time', () {
      final result = DateTimeFormatter.eventDetailsFull(dt);
      expect(result, 'Friday, July 25, 2025 • 10:00 PM');
    });
  });
}
