import 'package:ember_trips/constants.dart';
import 'package:ember_trips/features/trip_details/controller/trip_details_controller.dart';
import 'package:ember_trips/features/trip_details/widgets/amenities_widget.dart';
import 'package:ember_trips/features/trip_details/widgets/seats_available_widget.dart';
import 'package:ember_trips/features/trip_details/widgets/stop_points_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:ember_trips/utils.dart';
import 'package:ember_trips/theme.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({super.key});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  final TripDetailsController _controller = Get.put(TripDetailsController());

  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];
  GoogleMapController? _mapController;
  String _mapStyle = '';

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    _controller.fetchTripDetails().then((_) {
      _getPolylinePoints();
    });
  }

  Future<void> _loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style/map_style.json');
  }

  Future<void> _getPolylinePoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    try {
      final origin = _controller.origin.value;
      final destination = _controller.destination.value;

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: GOOGLE_MAP_API_KEY,
        request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.driving,
        ),
      );

      if (result.points.isNotEmpty) {
        polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
        _setPolylines();
      }
    } catch (e) {
      debugPrint('Error getting polyline points: $e');
    }
  }

  void _setPolylines() {
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: polylineCoordinates,
          color: AppTheme.polyLineColor,
          width: 5,
        ),
      );
    });
  }

  void _animateToMarker(String markerId) {
    final marker = _controller.markers.firstWhere(
      (marker) => marker.markerId.value == markerId,
      orElse: () => throw Exception("Marker not found"),
    );

    _mapController?.animateCamera(CameraUpdate.newLatLng(marker.position));
    _mapController?.showMarkerInfoWindow(marker.markerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Obx(() {
        final tripDetails = _controller.tripDetails.value;
        final origin = _controller.origin.value;
        final destination = _controller.destination.value;

        if (_controller.isMapLoading.value) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppTheme.cardTextColor,
          ));
        } else if (_controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  color: AppTheme.errorColor,
                  size: 40,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${_controller.errorMessage.value}',
                  style: AppTheme.errorTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (tripDetails.route == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning,
                  color: AppTheme.warningColor,
                  size: 40,
                ),
                const SizedBox(height: 16),
                Text(
                  'Trip details not available.',
                  style: AppTheme.warningTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else {
          return Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: origin,
                    zoom: 15,
                  ),
                  style: _mapStyle,
                  markers: _controller.markers,
                  polylines: _polylines,
                  mapType: MapType.normal,
                  zoomControlsEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                ),
              ),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.4)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.93, 1],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds);
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      color: AppTheme.backgroundColor,
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Bus No: ${tripDetails.vehicle?.plateNumber ?? "Loading"}",
                                style: AppTheme.timeTextStyle,
                              ),
                              InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Last Updated: ${AppUtils.formatTimeWithAmPm(tripDetails.vehicle!.gps!.lastUpdated!)}"),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                  _animateToMarker("vehicle");
                                },
                                child: Text(
                                  "Track Bus",
                                  style: AppTheme.linkTextStyle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "${tripDetails.vehicle?.name ?? "Loading"},",
                            style: AppTheme.bodyTextStyle,
                          ),
                          if (tripDetails.vehicle?.colour != null)
                            Text(
                              "${tripDetails.vehicle?.colour} ${tripDetails.vehicle?.type} by ${tripDetails.vehicle?.brand}",
                              style: AppTheme.bodyTextStyle,
                            ),
                          const SizedBox(height: 12),
                          SeatsAvailableWidget(
                            nosBicycle: tripDetails.vehicle?.bicycle ?? 0,
                            nosSeats: tripDetails.vehicle?.seat ?? 0,
                            nosWheelchair: tripDetails.vehicle?.wheelchair ?? 0,
                          ),
                          const SizedBox(height: 12),
                          BusAmenities(
                            hasToilet: tripDetails.vehicle?.hasToilet ?? false,
                            hasWifi: tripDetails.vehicle?.hasWifi ?? false,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tripDetails.route?.length ?? 0,
                            itemBuilder: (context, index) {
                              final stop = tripDetails.route![index];
                              final isPast =
                                  stop.departure?.isBefore(DateTime.now()) ??
                                      false;
                              return StopTimeLineTile(
                                isFirst: index == 0,
                                isLast: index == tripDetails.route!.length - 1,
                                isPast: isPast,
                                stop: stop,
                                onMapIconTapped: () {
                                  _animateToMarker(
                                      tripDetails.route![index].id.toString());
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
