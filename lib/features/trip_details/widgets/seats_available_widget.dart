import 'package:ember_trips/theme.dart';
import 'package:flutter/material.dart';

class SeatsAvailableWidget extends StatelessWidget {
  final int nosSeats;
  final int nosBicycle;
  final int nosWheelchair;

  const SeatsAvailableWidget({
    Key? key,
    required this.nosSeats,
    required this.nosBicycle,
    required this.nosWheelchair,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRow(Icons.airline_seat_recline_normal, "Seating", nosSeats),
        _buildRow(Icons.pedal_bike, "Bicycle", nosBicycle),
        _buildRow(Icons.accessible, "WheelChair", nosWheelchair),
      ],
    );
  }

  Widget _buildRow(IconData icon, String label, int count) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.secondaryTextColor),
        const SizedBox(width: 12),
        Text(
          "$label: $count",
          style: AppTheme.bodyTextStyle.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
