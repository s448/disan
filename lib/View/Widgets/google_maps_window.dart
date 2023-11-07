import 'package:disan/Core/ultis/snakbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Controller/location_controller.dart';

class MapPicker extends StatelessWidget {
  final _mapController = Get.find<MapController>();

  MapPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: Get.height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              var maxWidth = constraints.biggest.width;
              var maxHeight = constraints.biggest.height;

              return Stack(
                children: <Widget>[
                  SizedBox(
                    height: maxHeight,
                    width: maxWidth,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _mapController.initCoordinates,
                        zoom: _mapController.initZoom,
                      ),
                      onMapCreated: _mapController.onMapCreated,
                      onCameraMove: (CameraPosition newPosition) {
                        _mapController.position = newPosition.target;
                      },
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: false,
                      zoomGesturesEnabled: true,
                      padding: const EdgeInsets.all(0),
                      buildingsEnabled: true,
                      cameraTargetBounds: CameraTargetBounds.unbounded,
                      compassEnabled: true,
                      indoorViewEnabled: false,
                      mapToolbarEnabled: true,
                      minMaxZoomPreference: MinMaxZoomPreference.unbounded,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                      trafficEnabled: false,
                    ),
                  ),
                  Positioned(
                    top: Get.height / 2 - 50,
                    right: Get.width / 2 - 50 / 2,
                    child: const Icon(
                      Icons.person_pin_circle,
                      size: 50,
                      color: Colors.red,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 30,
                    child: Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: _mapController.goToCurrentLocation,
                        icon: const Icon(Icons.my_location),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "hero 1",
        onPressed: () => Get.back(),
        child: const Icon(
          Icons.arrow_forward_ios,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            if (_mapController.position != null) {
              Get.back();
              customSnackbar("Position was selected", "");
            }
          },
          label: Text("Pick Location".tr),
          icon: const Icon(
            Icons.location_on_outlined,
          ),
        ),
      ),
    );
  }
}
