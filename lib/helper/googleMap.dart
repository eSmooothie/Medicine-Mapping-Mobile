import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart'
    show ByteData, PlatformException, rootBundle;
import 'package:location/location.dart';
import 'package:research_mobile_app/exports.dart';
import 'package:research_mobile_app/objects/pharmacy.dart';
import 'package:research_mobile_app/request/requestPharmacy.dart';

class Gmap {
  late GoogleMapController mapController;
  late String _mapStyle;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  final LatLng _center = const LatLng(8.2280, 124.2452);
  late LocationData _userPos;

  BuildContext context;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> _circles = <CircleId, Circle>{};
  StreamSubscription? _locationSubscription;
  Location _userLocationTracker = new Location();

  bool darkMode = false;

  Gmap({required this.context}) {
    String loadMapStyle =
        darkMode ? 'assets/dark_mapStyle.txt' : 'assets/default_mapStyle.txt';
    rootBundle.loadString(loadMapStyle).then((string) {
      _mapStyle = string;
    });
  }

  void _addMarker({
    required var id,
    required String name,
    required LatLng position,
    required void Function()? onPressed,
  }) {
    MarkerId markerId = MarkerId(id.toString());
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
                    "$name",
                    style: TextStyle(color: Colors.white, fontSize: 34),
                  ),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      onPressed: onPressed,
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

  Future<void> _initPharmacy() async {
    print("initializing pharmacy marker in the google map.");
    List<Pharmacy> pharmacies = await RequestPharmacy().QueryAll();

    // loop
    pharmacies.forEach((Pharmacy pharmacy) {
      double lat = double.parse(pharmacy.lat);
      double lng = double.parse(pharmacy.lng);
      LatLng pos = LatLng(lat, lng);
      Map<String, Object> args = {
        'from': landingPage,
        'pharmacy': pharmacy,
      };
      _addMarker(
          id: pharmacy.id,
          name: pharmacy.name,
          position: pos,
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              pharmacyInfoPage,
              arguments: args,
            );
          });
    });
  }

  // The larger the value of zoom the more it is closer to the map.
  Future<Widget> initMap({
    double zoom = 12.0,
  }) async {
    // wait for the user to allow the app to use the location
    bool isPermitted = await _checkLocationService();

    if (!isPermitted) {
      throw Exception(
          "Enable to load the map please do allow the application to access your location. Thank you.");
    }
    await _initPharmacy();
    LocationData _userPos = await _userLocationTracker.getLocation();
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) async {
        mapController = controller;
        mapController.setMapStyle(_mapStyle);

        mapController
            .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
          bearing: 0,
          target: LatLng(_userPos.latitude!, _userPos.longitude!),
          tilt: 0,
          zoom: 15.00,
        )));
      },
      myLocationEnabled: isPermitted,
      myLocationButtonEnabled: false,
      initialCameraPosition: CameraPosition(target: _center, zoom: zoom),
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      markers: Set<Marker>.of(_markers.values),
      circles: Set<Circle>.of(_circles.values),
    );
  }

  Future<bool> _checkLocationService() async {
    _serviceEnabled = await _userLocationTracker.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _userLocationTracker.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await _userLocationTracker.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _userLocationTracker.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  void dispose() {
    mapController.dispose();
  }
}
