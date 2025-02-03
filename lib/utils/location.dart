import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
class LocationInitializer extends StatefulWidget {
  final Function(LatLng) onLocationUpdated;

  const LocationInitializer({super.key, required this.onLocationUpdated});

  @override
  _LocationInitializerState createState() => _LocationInitializerState();
}

class _LocationInitializerState extends State<LocationInitializer> {
  bool _isInitializing = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      bool serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await geolocator.Geolocator.requestPermission() == geolocator.LocationPermission.whileInUse;
        if (!serviceEnabled) {
          setState(() {
            _hasError = true;
          });
          return;
        }
      }

      geolocator.LocationPermission permission = await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
        if (permission != geolocator.LocationPermission.whileInUse && permission != geolocator.LocationPermission.always) {
          setState(() {
            _hasError = true;
          });
          return;
        }
      }

      geolocator.Position position = await geolocator.Geolocator.getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high);

      widget.onLocationUpdated(LatLng(position.latitude, position.longitude));
      setState(() {
        _isInitializing = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(child: Text('Location permission denied or error occurred.'));
    }

    if (_isInitializing) {
      return Center(child: CircularProgressIndicator());
    }

    return Container();
  }
}
