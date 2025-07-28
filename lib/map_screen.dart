import 'dart:async';

import 'package:flutter/material.dart';
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
    target: LatLng(30.042316, 31.190980),
    zoom: 14,
  );
  String mapStyle = '';
  @override
  void initState() {
    _loadMapStyle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        style: mapStyle,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _loadMapStyle();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          moveToCairo();
        },
        child: const Icon(Icons.location_city),
      ),
    );
  }

  void moveToCairo() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(30.145461204825303, 31.720157719774647),
          zoom: 11,
        ),
      ),
    );
  }

  void _loadMapStyle() async {
    final String style = await DefaultAssetBundle.of(
      context,
    ).loadString('assets/map_style.json');
    setState(() {
      mapStyle = style;
    });
  }
}
