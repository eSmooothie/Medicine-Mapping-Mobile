import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class Gmap {
  late GoogleMapController mapController;
  late String _mapStyle;
  final LatLng _center = const LatLng(8.2280, 124.2452);

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  bool darkMode = false;

  Gmap() {
    String loadMapStyle =
        darkMode ? 'assets/dark_mapStyle.txt' : 'assets/default_mapStyle.txt';
    rootBundle.loadString(loadMapStyle).then((string) {
      _mapStyle = string;
    });
  }

  void _addMarker({
    required BuildContext context,
    required var id,
    required LatLng position,
  }) {
    MarkerId markerId = MarkerId(id);
    final Marker newMarker = Marker(
      markerId: markerId,
      position: position,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 200,
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Pharmacy Name",
                    style: TextStyle(color: Colors.white, fontSize: 34),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        print("marker tap. {$id}");
                      },
                      child: Text(
                        "View",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2.0)),
                          side: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // add the new marker in the list.
    _markers[markerId] = newMarker;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  void _initPharmacy({required BuildContext context}) {
    Map<String, LatLng> pharmaInfo = <String, LatLng>{};

    // query
    pharmaInfo["1"] = const LatLng(8.228210, 124.241222);
    pharmaInfo["2"] = const LatLng(8.232329, 124.237471);

    // loop
    pharmaInfo.forEach((key, value) {
      _addMarker(context: context, id: key, position: value);
    });
  }

  // The larger the value of zoom the more it is closer to the map.
  dynamic initMap({
    required BuildContext context,
    double zoom = 12.0,
    bool showPharmacy = true,
  }) {
    if (showPharmacy) {
      _initPharmacy(context: context);
    }

    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: zoom),
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      markers: Set<Marker>.of(_markers.values),
    );
  }
}
