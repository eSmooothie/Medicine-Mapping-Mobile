import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart' as geo;

import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:location/location.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(8.2280, 124.2452), zoom: 15.0);
  late GoogleMapController mapController;
  loc.Location location = new loc.Location();

  Set<Marker> markers = {};
// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};
  _getAddress() async {
    LocationData? myLocation;

    try {
      myLocation = await location.getLocation();
      final List<geo.Placemark> myPlacemark =
          await geo.placemarkFromCoordinates(
              myLocation.latitude!, myLocation.longitude!);

      geo.Placemark myPlace = myPlacemark[2];

      String _currentAddress =
          "${myPlace.name}, ${myPlace.locality}, ${myPlace.postalCode}, ${myPlace.country}";

      LatLng dest = LatLng(8.238046, 124.244206);
      final List<geo.Placemark> destPlacemark =
          await geo.placemarkFromCoordinates(
        dest.latitude,
        dest.longitude,
      );

      geo.Placemark destPlace = destPlacemark[2];

      String _destAddress =
          "${destPlace.name}, ${destPlace.locality}, ${destPlace.postalCode}, ${destPlace.country}";

      print("sAdd: $_currentAddress");
      print("dAdd: $_destAddress");

      // Convert  the given address into Location

      // LatLng startPos = LatLng(
      //   startLoc[0].latitude,
      //   startLoc[0].longitude,
      // );
      // LatLng destPos = LatLng(
      //   dest[0].latitude,
      //   dest[0].longitude,
      // );
      LatLng startPos = LatLng(
        myLocation.latitude!,
        myLocation.longitude!,
      );
      LatLng destPos = LatLng(
        dest.latitude,
        dest.longitude,
      );

      print("sPos: $startPos dPos: $destPos");

      String startCoordinatesString =
          '(${startPos.latitude}, ${startPos.longitude})';
      String destinationCoordinatesString =
          '(${destPos.latitude}, ${destPos.longitude})';

      // Start Location Marker
      Marker startMarker = Marker(
        markerId: MarkerId(startCoordinatesString),
        position: startPos,
        infoWindow: InfoWindow(
          title: 'Start $startCoordinatesString',
          snippet: _currentAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Destination Location Marker
      Marker destinationMarker = Marker(
        markerId: MarkerId(destinationCoordinatesString),
        position: destPos,
        infoWindow: InfoWindow(
          title: 'Destination $destinationCoordinatesString',
          snippet: _destAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      // Add the markers to the list
      markers.add(startMarker);
      markers.add(destinationMarker);

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startPos.latitude <= destPos.latitude)
          ? startPos.latitude
          : destPos.latitude;
      double minx = (startPos.longitude <= destPos.longitude)
          ? startPos.longitude
          : destPos.longitude;
      double maxy = (startPos.latitude <= destPos.latitude)
          ? destPos.latitude
          : startPos.latitude;
      double maxx = (startPos.longitude <= destPos.longitude)
          ? destPos.longitude
          : startPos.longitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;
      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          100.0,
        ),
      );

      // Draw route
      // Object for PolylinePoints
      PolylinePoints polylinePoints;

      // List of coordinates to join
      List<LatLng> polylineCoordinates = [];

      // Initializing PolylinePoints
      polylinePoints = PolylinePoints();

      // Generating the list of coordinates to be used for
      // drawing the polylines
      String googleApiKey = "AIzaSyDzgtPJeqX3e4XCPTelTsenA-gPz3LzxaY";
      PointLatLng origin =
          PointLatLng(myLocation.latitude!, myLocation.longitude!);
      PointLatLng destination = PointLatLng(dest.latitude, dest.longitude);
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        origin,
        destination,
      );

      // adding the coordinate to the list
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          LatLng addPoint = LatLng(point.latitude, point.longitude);
          polylineCoordinates.add(addPoint);
        });
      }

      // Defining an ID
      PolylineId polylineId = PolylineId("poly");

      // Initializing Polyline
      Polyline polyline = Polyline(
        polylineId: polylineId,
        color: Colors.red,
        points: polylineCoordinates,
        width: 3,
      );

      polylines[polylineId] = polyline;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getAddress();
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialLocation,
            markers: Set<Marker>.from(markers),
            polylines: Set<Polyline>.of(polylines.values),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
        ],
      ),
    );
  }
}
