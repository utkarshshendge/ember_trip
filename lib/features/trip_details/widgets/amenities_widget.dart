import 'package:ember_trips/theme.dart';
import 'package:flutter/material.dart';

class BusAmenities extends StatelessWidget {
  final bool hasWifi;
  final bool hasToilet;

  const BusAmenities({Key? key, required this.hasWifi, required this.hasToilet})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, bool> amenities = {
      "has_wifi": hasWifi,
      "has_toilet": hasToilet,
    };

    final Map<String, IconData> icons = {
      "has_wifi": Icons.wifi,
      "has_toilet": Icons.family_restroom,
    };

    final Map<String, String> labels = {
      "has_wifi": "Wifi",
      "has_toilet": "Toilet",
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: amenities.keys.map((key) {
        return Row(
          children: [
            Icon(
              icons[key] ?? Icons.help_outline,
              color: AppTheme.secondaryTextColor,
            ),
            const SizedBox(width: 12),
            Icon(
              amenities[key]! ? Icons.check : Icons.close,
              color: amenities[key]!
                  ? AppTheme.statusAllowedColor
                  : AppTheme.statusNotAllowedColor,
            ),
            const SizedBox(width: 12),
            Text(
              labels[key] ?? "Unknown",
              style: AppTheme.bodyTextStyle,
            ),
          ],
        );
      }).toList(),
    );
  }
}
