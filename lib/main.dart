import 'package:flutter/material.dart';
import 'traffic_light_screen.dart';

void main() {
  runApp(TrafficLightApp());
}

class TrafficLightApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TrafficLightScreen(),
    );
  }
}
