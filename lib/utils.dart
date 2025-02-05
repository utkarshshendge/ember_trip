class AppUtils {
  static String formatTimeWithAmPm(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert to 12-hour format
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour; // Handle midnight (0 -> 12)

    // Format minutes to always be two digits
    String minuteStr = minute.toString().padLeft(2, '0');

    return '$hour:$minuteStr $period';
  }

  static formatDate(DateTime dateTime) {
    final List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    String month = months[dateTime.month - 1]; // Get month abbreviation
    String day = dateTime.day.toString(); // Get day of the month

    return "$month $day";
  }
}
