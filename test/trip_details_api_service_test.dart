import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ember_trips/features/trip_details/repository/fetch_trip_details.dart';
import 'package:ember_trips/features/trip_details/model/trip_details_model.dart';

// Use alias for generated mocks
import 'trip_details_api_service_test.mocks.dart' as generated;

@GenerateMocks([http.Client])
void main() {
  late TripDetailsApiService apiService;
  late generated.MockClient mockClient;

  setUp(() {
    mockClient = generated.MockClient();
    apiService = TripDetailsApiService(client: mockClient);
  });

  group('TripDetailsApiService', () {
    test('_getFirstTripUid should return a trip UID when API response is valid',
        () async {
      final mockResponse = jsonEncode({
        "quotes": [
          {
            "legs": [
              {"trip_uid": "trip_123"}
            ]
          }
        ]
      });

      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final tripUid = await apiService.getFirstTripUid();
      expect(tripUid, equals("trip_123"));
    });

    test('_getFirstTripUid should throw an exception when no quotes are found',
        () async {
      final mockResponse = jsonEncode({"quotes": []});

      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      expect(() async => await apiService.getFirstTripUid(), throwsException);
    });

    test('getTripDetails should return TripDetailsModel on successful response',
        () async {
      final mockTripUidResponse = jsonEncode({
        "quotes": [
          {
            "legs": [
              {"trip_uid": "trip_123"}
            ]
          }
        ]
      });

      when(mockClient.get(argThat(isA<Uri>()
              .having((u) => u.host, 'host', 'api.ember.to')
              .having((u) => u.path, 'path', '/v1/quotes/')
              .having(
                  (u) => u.queryParameters['destination'], 'destination', '42')
              .having((u) => u.queryParameters['origin'], 'origin', '13')
              .having((u) => u.queryParameters['arrival_date_from'],
                  'arrival_date_from', isNotNull)
              .having((u) => u.queryParameters['departure_date_to'],
                  'departure_date_to', isNotNull))))
          .thenAnswer((_) async => http.Response(mockTripUidResponse, 200));

      // Mock the response for getTripDetails
      final tripDetailsResponse = jsonEncode({
        "route": [
          {
            "id": 1619361,
            "departure": {"scheduled": "2025-02-06T12:00:00+00:00"},
            "arrival": {"scheduled": "2025-02-06T12:00:00+00:00"},
            "location": {
              "id": 218,
              "type": "STOP_POINT",
              "name": "Dundee Slessor Gardens",
              "region_name": "Dundee",
              "code": "DUN",
              "code_detail": "Slessor Gardens",
              "detailed_name": "Slessor Gardens",
              "lon": -2.966036,
              "lat": 56.459319,
              "atco_code": "6400LL99",
              "has_future_activity": true,
              "timezone": "Europe/London",
              "zone": [
                {
                  "latitude": 56.459542218608334,
                  "longitude": -2.966276800467473
                },
                {
                  "latitude": 56.459116641801984,
                  "longitude": -2.96554414986868
                },
                {
                  "latitude": 56.45900595021118,
                  "longitude": -2.965733748522858
                },
                {
                  "latitude": 56.45942485291969,
                  "longitude": -2.9664919017183045
                },
                {
                  "latitude": 56.459542218608334,
                  "longitude": -2.966276800467473
                }
              ],
              "heading": 135,
              "area_id": 13
            },
            "allow_boarding": true,
            "allow_drop_off": false,
            "booking_cut_off_mins": 0,
            "pre_booked_only": false,
            "skipped": false
          },
          {
            "id": 1619362,
            "departure": {"scheduled": "2025-02-06T12:09:00+00:00"},
            "arrival": {"scheduled": "2025-02-06T12:09:00+00:00"},
            "location": {
              "id": 2,
              "type": "STOP_POINT",
              "name": "Dundee West",
              "region_name": "Dundee West",
              "code": "DUN",
              "code_detail": "Dundee West",
              "detailed_name": "Apollo Way",
              "lon": -3.05468,
              "lat": 56.462677,
              "google_place_id": "ChIJE2gJVwlDhkgRBp7tM4HaqS0",
              "atco_code": "6400L00019",
              "has_future_activity": true,
              "timezone": "Europe/London",
            },
            "allow_boarding": true,
            "allow_drop_off": true,
            "booking_cut_off_mins": 10,
            "pre_booked_only": true,
            "skipped": false
          },
        ],
        "vehicle": {
          "bicycle": 2,
          "wheelchair": 1,
          "seat": 40,
          "id": 24,
          "plate_number": "SG72 NCE",
          "name": "Yutong Coach (SG72 NCE)",
          "has_wifi": true,
          "has_toilet": true,
          "type": "coach",
          "brand": "Ember",
          "colour": "black",
          "is_backup_vehicle": false,
          "owner_id": 1,
          "gps": {
            "last_updated": "2025-02-05T12:26:00.091000+00:00",
            "longitude": -2.89379,
            "latitude": 56.4840116,
            "heading": 255
          }
        },
        "description": {
          "route_number": "E1",
          "pattern_id": 37152,
          "calendar_date": "2025-02-06",
          "type": "public",
          "is_cancelled": false,
          "route_id": 1
        }
      });

      when(mockClient.get(Uri.parse('https://api.ember.to/v1/trips/trip_123/')))
          .thenAnswer((_) async => http.Response(tripDetailsResponse, 200));

      // Call getTripDetails
      final tripDetails = await apiService.getTripDetails();

      // Verify the result
      expect(tripDetails, isA<TripDetailsModel>());
      // Correct the expected vehicle type if necessary
      expect(tripDetails?.vehicle?.type, equals("coach")); // U
    });

    test('getTripDetails should throw an exception if trip ID is null',
        () async {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response("{}", 200));

      expect(() async => await apiService.getTripDetails(), throwsException);
    });

    test('getTripDetails should throw an exception when API returns an error',
        () async {
      when(mockClient.get(any))
          .thenAnswer((_) async => http.Response("Internal Server Error", 500));

      expect(() async => await apiService.getTripDetails(), throwsException);
    });
  });
}
