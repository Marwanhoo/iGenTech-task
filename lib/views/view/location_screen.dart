import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igentech_task/controllers/app_cubit/app_cubit.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.onLocationSelected});
  final Function(Position) onLocationSelected;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? currentPosition;

  // Function to get the current location
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show dialog to ask the user to enable location services
      if (mounted) {
        BlocProvider.of<AppCubit>(context).showLocationServiceDialog(context);
      }
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
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    setState(() {
      currentPosition = position;
    });
    widget.onLocationSelected(position);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          currentPosition != null
              ? Text(
                  'Latitude: ${currentPosition?.latitude}, Longitude: ${currentPosition?.longitude}')
              : const Text('No location data'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: getCurrentLocation,
            child: const Text('Get Current Location'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AppCubit>(context)
                  .openInGoogleMaps(currentPosition);
            },
            child: const Text('Open in Google Maps'),
          ),
        ],
      ),
    );
  }
}