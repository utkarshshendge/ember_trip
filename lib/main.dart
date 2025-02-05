import 'package:ember_trips/features/trip_details/pages/trip_details.dart';
import 'package:ember_trips/features/core/global_widgets/custom_marker_icons.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await MarkerIcons().loadIcons();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TripDetails(),
    );
  }
}
