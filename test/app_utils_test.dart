import 'package:ember_trips/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUtils', () {
    test('formatTimeWithAmPm should correctly format time in 12-hour format',
        () {
      expect(
          AppUtils.formatTimeWithAmPm(DateTime(2024, 1, 1, 0, 5)), '12:05 AM');
      expect(AppUtils.formatTimeWithAmPm(DateTime(2024, 1, 1, 12, 30)),
          '12:30 PM');
      expect(AppUtils.formatTimeWithAmPm(DateTime(2024, 1, 1, 23, 45)),
          '11:45 PM');
      expect(
          AppUtils.formatTimeWithAmPm(DateTime(2024, 1, 1, 9, 15)), '9:15 AM');
    });

    test('formatDate should correctly format date as "MMM DD"', () {
      expect(AppUtils.formatDate(DateTime(2024, 1, 1)), 'Jan 1');
      expect(AppUtils.formatDate(DateTime(2024, 12, 25)), 'Dec 25');
      expect(AppUtils.formatDate(DateTime(2024, 7, 4)), 'Jul 4');
    });
  });
}
