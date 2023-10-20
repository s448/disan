import 'package:disan/Contoller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsPage extends StatelessWidget {
  GoogleMapsPage({super.key});
  final _mapController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a Location'),
      ),
      body: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.422, -122.084), // Initial map center
            zoom: 15,
          ),
          onTap: _mapController.selectLocation,
          markers: <Marker>{
            Marker(
              markerId: const MarkerId('picked-location'),
              position: _mapController.selectedLocation,
            ),
          }),
      bottomNavigationBar: FloatingActionButton.extended(
        onPressed: () {
          // Handle the selected location
          // Do something with _mapController.selectedLocation
          print(
              'Selected location: ${_mapController.selectedLocation.latitude}, ${_mapController.selectedLocation.longitude}');
        },
        label: Text('Pick Location'),
        icon: Icon(Icons.location_pin),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
