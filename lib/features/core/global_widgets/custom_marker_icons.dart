import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIcons {
  static final MarkerIcons _instance = MarkerIcons._internal();

  factory MarkerIcons() => _instance;

  MarkerIcons._internal();

  BitmapDescriptor? busIcon;

  Future<void> loadIcons() async {
    WidgetsFlutterBinding.ensureInitialized();

    try {
      busIcon = await BitmapDescriptor.asset(
        const ImageConfiguration(size: Size(60, 60)),
        'assets/location-pin.png',
      );
    } catch (e) {
      debugPrint('Error loading marker icons: $e');
    }
  }
}
