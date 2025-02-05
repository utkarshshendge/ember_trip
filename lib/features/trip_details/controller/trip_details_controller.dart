import 'package:ember_trips/features/core/models/route_stop_model.dart';
import 'package:ember_trips/features/trip_details/model/trip_details_model.dart';
import 'package:ember_trips/features/trip_details/repository/fetch_trip_details.dart';
import 'package:ember_trips/features/core/global_widgets/custom_marker_icons.dart';
import 'package:ember_trips/utils.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailsController extends GetxController {
  final TripDetailsApiService _apiService = TripDetailsApiService();
  var tripDetails = TripDetailsModel().obs;
  var markers = <Marker>{}.obs;
  final isMapLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final MarkerIcons _markerIcons = MarkerIcons();

  // Add origin and destination as Rx variables
  var origin = LatLng(0.0, 0.0).obs;
  var destination = LatLng(0.0, 0.0).obs;

  Future<void> fetchTripDetails() async {
    try {
      isMapLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final data = await _apiService.getTripDetails();
      if (data != null) {
        tripDetails.value = data;
        _setupMarkers();
      } else {
        throw Exception('Trip details are null.');
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Error fetching trip details: $e');
    } finally {
      isMapLoading.value = false;
    }
  }

  void _setupMarkers() {
    markers.clear();
    if (tripDetails.value.route != null) {
      List<RouteStop> stops = tripDetails.value.route!;

      // Set origin and destination based on the first and last stops
      if (stops.isNotEmpty) {
        var firstStop = stops.first;
        var lastStop = stops.last;

        if (firstStop.location != null) {
          origin.value = LatLng(
              firstStop.location!.lat ?? 0.0, firstStop.location!.lon ?? 0.0);
        }

        if (lastStop.location != null) {
          destination.value = LatLng(
              lastStop.location!.lat ?? 0.0, lastStop.location!.lon ?? 0.0);
        }
      }

      for (var i = 0; i < stops.length; i++) {
        var stop = stops[i];

        if (stop.location != null) {
          markers.add(
            Marker(
              markerId: MarkerId(stop.id.toString()),
              position:
                  LatLng(stop.location!.lat ?? 0.0, stop.location!.lon ?? 0.0),
              infoWindow: InfoWindow(
                  title: AppUtils.formatTimeWithAmPm(stop.departure!),
                  snippet: stop.location!.name),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                i == 0
                    ? BitmapDescriptor.hueBlue // First stop
                    : (i == stops.length - 1
                        ? BitmapDescriptor.hueRose // Last stop
                        : (stop.allowBoarding == true
                            ? BitmapDescriptor.hueGreen
                            : BitmapDescriptor.hueRed)), // Default
              ),
            ),
          );
        }
      }

      markers.add(
        Marker(
          markerId: const MarkerId("vehicle"),
          position: LatLng(tripDetails.value.vehicle?.gps?.latitude ?? 0.0,
              tripDetails.value.vehicle?.gps?.longitude ?? 0.0),
          infoWindow: InfoWindow(
              title: "Bus", snippet: tripDetails.value.vehicle?.name),
          icon: _markerIcons.busIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        ),
      );
    }
  }
}
