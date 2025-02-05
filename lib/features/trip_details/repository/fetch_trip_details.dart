import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ember_trips/features/trip_details/model/trip_details_model.dart';

class TripDetailsApiService {
  static const String _baseUrl = 'https://api.ember.to/v1/trips';
  static const String _quotesUrl = 'https://api.ember.to/v1/quotes/';

  final http.Client client;

  TripDetailsApiService._internal(this.client);

  factory TripDetailsApiService({http.Client? client}) {
    return TripDetailsApiService._internal(client ?? http.Client());
  }

  String getNextDayIsoDateAt(int hour, [int minute = 0]) {
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(Duration(days: 1));
    DateTime targetTime =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day, hour, minute);
    return targetTime.toUtc().toIso8601String();
  }

  Future<String?> getFirstTripUid() async {
    String arrivalDateFrom = getNextDayIsoDateAt(0);
    String departureDateTo = getNextDayIsoDateAt(23, 59);

    final Uri url = Uri.parse(_quotesUrl).replace(queryParameters: {
      'destination': '42',
      'origin': '13',
      'arrival_date_from': arrivalDateFrom,
      'departure_date_to': departureDateTo,
    });

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['quotes'] != null && data['quotes'].isNotEmpty) {
          final tripUid = data['quotes'][0]['legs'][0]['trip_uid'];
          return tripUid;
        } else {
          throw Exception('No quotes found in the response.');
        }
      } else {
        throw Exception(
            'Failed to load quotes: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching quotes: $e');
    }
  }

  Future<TripDetailsModel?> getTripDetails() async {
    try {
      final tripUid = await getFirstTripUid();
      if (tripUid == null) {
        throw Exception(
            'We could not get a valid tripID at the moment. Unable to fetch trip details.');
      }

      final Uri url = Uri.parse('$_baseUrl/$tripUid/');
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return TripDetailsModel.fromJson(data);
      } else {
        throw Exception(
            'Failed to load trip details: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception(
          'Error fetching trip details: Please check your internet connection and try again');
    }
  }
}
