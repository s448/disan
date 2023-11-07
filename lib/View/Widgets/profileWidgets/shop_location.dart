import 'package:disan/Core/extension/url_launch_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopLocationWidget extends StatelessWidget {
  ShopLocationWidget({super.key, required this.lat, required this.long});
  final double lat;
  final double long;
  late GoogleMapController _mapController;

  void openLocationInMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    UrlLauncherService.launch(url);
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialPosition = CameraPosition(
      target: LatLng(lat, long),
      zoom: 14.0,
    );
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
      width: Get.width,
      height: Get.height * 0.2,
      child: InkWell(
        onTap: () => openLocationInMaps(lat, long),
        child: GoogleMap(
          initialCameraPosition: initialPosition,
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
          },
          markers: {
            Marker(
              markerId: const MarkerId('location'),
              position: LatLng(lat, long),
            ),
          },
        ),
      ),
    );
  }
}
