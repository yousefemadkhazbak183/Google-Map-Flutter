import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => MapSampleState();
}

class MapSampleState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(30.10189429846024, 31.374616987875225),
    zoom: 12,
  );
  String mapStyle = '';
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        style: mapStyle,
        initialCameraPosition: _kGooglePlex,
        polylines: _polylines,
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);

          setState(() {
            _polylines.add(
              const Polyline(
                polylineId: PolylineId('Route'),
                color: Colors.green,

                points: [
                  LatLng(30.116190380064282, 31.417552930269608),
                  LatLng(30.10189429846024, 31.374616987875225),
                  LatLng(30.129807962623357, 31.36877048398477),
                ],
              ),
            );
            _getPolyLine();
          });
        },
      ),
    );
  }

  _getPolyLine() async {
    PolylinePoints polylinePoints = PolylinePoints(
      apiKey: "AIzaSyDcy2BaCQIrXNnoxlHQcgmIztwI1zHjC8Q",
    );
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: const PointLatLng(30.10189429846024, 31.374616987875225),
        destination: const PointLatLng(30.129807962623357, 31.36877048398477),
        mode: TravelMode.driving,
      ),
    );
  }
}
