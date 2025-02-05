class GPS {
  final DateTime? lastUpdated;
  final double? longitude;
  final double? latitude;
  final int? heading;

  GPS({
    this.lastUpdated,
    this.longitude,
    this.latitude,
    this.heading,
  });

  factory GPS.fromJson(Map<String, dynamic> json) {
    return GPS(
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : null,
      longitude: json['longitude'],
      latitude: json['latitude'],
      heading: json['heading'],
    );
  }
}
