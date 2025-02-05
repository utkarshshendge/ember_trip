import 'package:ember_trips/features/core/models/vehicle_gps_model.dart';

class Vehicle {
  final int? id;
  final int? wheelchair;

  final int? bicycle;

  final int? seat;

  final String? plateNumber;
  final String? name;
  final bool? hasWifi;
  final bool? hasToilet;
  final String? type;
  final String? brand;
  final String? colour;
  final GPS? gps;

  Vehicle(
      {this.id,
      this.plateNumber,
      this.name,
      this.hasWifi,
      this.hasToilet,
      this.type,
      this.brand,
      this.colour,
      this.gps,
      this.wheelchair,
      this.bicycle,
      this.seat});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      wheelchair: json['wheelchair'],
      seat: json['seat'],
      bicycle: json['bicycle'],
      plateNumber: json['plate_number'],
      name: json['name'],
      hasWifi: json['has_wifi'],
      hasToilet: json['has_toilet'],
      type: json['type'],
      brand: json['brand'],
      colour: json['colour'],
      gps: json['gps'] != null ? GPS.fromJson(json['gps']) : null,
    );
  }
}
