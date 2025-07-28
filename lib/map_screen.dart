import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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
  Set<Marker> markers = {};
  StreamSubscription<Position>? positionStream;
  bool _isPermissionGranted = false;
  LatLng? _currentLocation;

  @override
  void initState() {
    _loadMapStyle();
    super.initState();
    _checkPermissionRequest();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: _isPermissionGranted,
        style: mapStyle,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
          _loadMapStyle();
          markers.addAll({
            Marker(
              markerId: const MarkerId('Joe'),
              position: const LatLng(30.042316, 31.190980),
              infoWindow: const InfoWindow(title: 'Joe'),
              icon: await customIcon('assets/car_icon.png'),
            ),
            Marker(
              markerId: const MarkerId('Joe2'),
              position: const LatLng(30.04568171838561, 31.129671150500652),
              infoWindow: const InfoWindow(title: 'Nahia', snippet: 'Kerdasa'),
              icon: await customIcon('assets/car_icon.png'),
            ),
          });
        },
        markers: markers,
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

  Future<BitmapDescriptor> customIcon(String asset) async {
    return await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      asset,
    );
  }

  _checkPermissionRequest() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
      _getUserLocation();
    } else {}
  }

  void _getUserLocation() async {
    if (!_isPermissionGranted) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    if (_currentLocation == null) return;
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentLocation!, zoom: 14),
      ),
    );

    // Tracking
    startTracking();
  }

  void startTracking() {
    positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        ).listen((Position position) {
          setState(() {
            _currentLocation = LatLng(position.latitude, position.longitude);
          });

          _controller.future.then((controller) {
            controller.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: _currentLocation!, zoom: 15),
              ),
            );
          });
        });
  }
}
