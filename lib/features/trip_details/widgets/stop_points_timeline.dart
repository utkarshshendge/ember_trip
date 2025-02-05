import 'package:ember_trips/features/core/models/route_stop_model.dart';
import 'package:ember_trips/theme.dart';
import 'package:ember_trips/utils.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class StopTimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final RouteStop stop;
  final Function onMapIconTapped;

  const StopTimeLineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.isPast,
    required this.stop,
    required this.onMapIconTapped,
  });

  Widget _buildStatusIcon(bool isAllowed) {
    return Icon(
      isAllowed ? Icons.check : Icons.close,
      color: isAllowed
          ? AppTheme.statusAllowedColor
          : AppTheme.statusNotAllowedColor,
    );
  }

  Widget _buildStatusColumn(String label, bool isAllowed) {
    return Column(
      children: [
        Text(label, style: AppTheme.bodyTextStyle),
        _buildStatusIcon(isAllowed),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeStyle = AppTheme.timeTextStyle;
    final locationName = stop.location?.name ?? 'Unknown Location';
    final preBookTime = stop.bookingCutOffMins ?? 0;

    return SizedBox(
      width: 300,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast
              ? AppTheme.pastTimelineLineColor
              : AppTheme.timelineLineColor,
        ),
        indicatorStyle: IndicatorStyle(
          width: 24,
          color: isPast
              ? AppTheme.pastTimelineIndicatorColor
              : AppTheme.timelineIndicatorColor,
        ),
        endChild: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.cardBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Departs",
                      style: timeStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppTheme.secondaryTextColor,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onMapIconTapped();
                      },
                      child: Icon(
                        Icons.location_on_outlined,
                        color: AppTheme.secondaryTextColor,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${AppUtils.formatTimeWithAmPm(stop.departure ?? DateTime.now())}",
                          style: timeStyle,
                        ),
                        Text(
                          AppUtils.formatDate(stop.departure ?? DateTime.now()),
                          style: AppTheme.bodyTextStyle,
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        locationName,
                        style: timeStyle,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    color: AppTheme.dividerColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusColumn(
                        'Pre Book Only', stop.allowBoarding ?? false),
                    _buildStatusColumn('Boarding', stop.allowBoarding ?? false),
                    _buildStatusColumn('Drop-Off', stop.allowDropOff ?? false),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(
                    color: AppTheme.dividerColor,
                    thickness: 1,
                  ),
                ),
                preBookTime > 0
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "Booking closes at ${AppUtils.formatTimeWithAmPm(stop.departure!.subtract(Duration(minutes: preBookTime)))}",
                          style: AppTheme.bodyTextStyle,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
