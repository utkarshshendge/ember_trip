class Location {
  final int? id;
  final String? name;
  final String? regionName;
  final String? code;
  final double? lon;
  final double? lat;

  Location({
    this.id,
    this.name,
    this.regionName,
    this.code,
    this.lon,
    this.lat,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      regionName: json['region_name'],
      code: json['code'],
      lon: json['lon'],
      lat: json['lat'],
    );
  }
}
