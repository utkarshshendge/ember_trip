import 'package:ember_trips/features/core/models/route_stop_model.dart';
import 'package:ember_trips/features/core/models/vehicle_model.dart';

class TripDetailsModel {
  final List<RouteStop>? route;
  final Vehicle? vehicle;
  final RouteDescription? description;

  TripDetailsModel({
    this.route,
    this.vehicle,
    this.description,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      route: (json['route'] as List?)
          ?.map((item) => RouteStop.fromJson(item))
          .toList(),
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      description: json['description'] != null
          ? RouteDescription.fromJson(json['description'])
          : null,
    );
  }
}

class RouteDescription {
  final String? routeNumber;
  final int? patternId;
  final String? calendarDate;
  final String? type;
  final bool? isCancelled;
  final int? routeId;

  RouteDescription({
    this.routeNumber,
    this.patternId,
    this.calendarDate,
    this.type,
    this.isCancelled,
    this.routeId,
  });

  factory RouteDescription.fromJson(Map<String, dynamic> json) {
    return RouteDescription(
      routeNumber: json['route_number'],
      patternId: json['pattern_id'],
      calendarDate: json['calendar_date'],
      type: json['type'],
      isCancelled: json['is_cancelled'],
      routeId: json['route_id'],
    );
  }
}
