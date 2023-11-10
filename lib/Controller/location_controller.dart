import 'dart:async';
import 'package:disan/Core/ultis/snakbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng initCoordinates = const LatLng(30.0444, 31.2357);
  double initZoom = 14.4746;
  LatLng? position;

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Future<void> goToCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Geolocator.openLocationSettings();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          dangerSnackbar("Location permissions are denied".tr, "".tr);
          throw 'Location permissions are denied.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        dangerSnackbar("Location permissions are permanently denied".tr, "");
      }

      Position position = await Geolocator.getCurrentPosition();
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: initZoom,
          ),
        ),
      );
    } catch (e) {
      dangerSnackbar(e.toString(), "");
    }
  }
}
