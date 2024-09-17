import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? _currentPosition;

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show dialog to ask the user to enable location services
      _showLocationServiceDialog();
      return;
    }

// Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // If permissions are granted, get the position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = position;
    });
  }

  // Function to show dialog when location services are disabled
  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text('Please enable location services to proceed.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Open Settings'),
            onPressed: () async {
              Navigator.of(context).pop();
              // Open location settings (platform-specific)
              try {
                bool opened = await Geolocator.openLocationSettings();
                if (!opened) {
                  throw 'Could not open location settings';
                }
              } catch (e) {
                print('Error: $e');
                // Show error message to the user
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Could not open location settings.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Function to open Google Maps with the current location
  Future<void> _openInGoogleMaps() async {
    if (_currentPosition != null) {
      final latitude = _currentPosition!.latitude;
      final longitude = _currentPosition!.longitude;
      final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        throw 'Could not open Google Maps';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _currentPosition != null
              ? Text('Latitude: ${_currentPosition?.latitude}, Longitude: ${_currentPosition?.longitude}')
              : const Text('No location data'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _getCurrentLocation,
            child: const Text('Get Current Location'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _openInGoogleMaps,
            child: const Text('Open in Google Maps'),
          ),
        ],
      ),
    );
  }
}