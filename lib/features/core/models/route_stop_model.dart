import 'package:ember_trips/features/core/models/location_model.dart';

class RouteStop {
  final int? id;
  final DateTime? departure;
  final DateTime? arrival;
  final Location? location;
  final bool? allowBoarding;
  final bool? allowDropOff;
  final int? bookingCutOffMins;

  RouteStop(
      {this.id,
      this.departure,
      this.arrival,
      this.location,
      this.allowBoarding,
      this.allowDropOff,
      this.bookingCutOffMins});

  factory RouteStop.fromJson(Map<String, dynamic> json) {
    return RouteStop(
      id: json['id'],
      bookingCutOffMins: json['booking_cut_off_mins'],
      departure: json['departure']?['scheduled'] != null
          ? DateTime.parse(json['departure']['scheduled'])
          : null,
      arrival: json['arrival']?['scheduled'] != null
          ? DateTime.parse(json['arrival']['scheduled'])
          : null,
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      allowBoarding: json['allow_boarding'],
      allowDropOff: json['allow_drop_off'],
    );
  }
}
