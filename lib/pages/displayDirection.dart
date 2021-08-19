import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DisplayDirection extends StatefulWidget {
  const DisplayDirection({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;
  @override
  _DisplayDirectionState createState() => _DisplayDirectionState();
}

class _DisplayDirectionState extends State<DisplayDirection> {
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(8.2280, 124.2452), zoom: 12.0);
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  // Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};
  var arguments;
  var bounds;
  var steps;
  var overviewPolyline;
  var destinationLocation;

  void _setRoute() {
    print("Setting marker");
    MarkerId markerId = MarkerId(destinationLocation.toString());
    Marker destinationMarker = Marker(
      markerId: markerId,
      position: destinationLocation,
      icon: BitmapDescriptor.defaultMarker,
    );

    // Add the markers to the list
    markers.add(destinationMarker);
    print("Done marker");
    print("Setting up camera bounds.");
    double southWestLatitude = bounds["southwest"]["lat"];
    double southWestLongitude = bounds["southwest"]["lng"];

    double northEastLatitude = bounds["northeast"]["lat"];
    double northEastLongitude = bounds["northeast"]["lng"];
    print("Done camera bounds");
    print("Animating map camera.");
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
    print("Done animating");
    print("Drawing route");
    // Draw route
    // Object for PolylinePoints
    PolylinePoints polylinePoints;
    // List of coordinates to join
    List<LatLng> polylineCoordinates = [];
    // Initializing PolylinePoints
    print("Initializing polyline points.");
    polylinePoints = PolylinePoints();
    String encodedOverviewPolyline = overviewPolyline["points"];
    List<PointLatLng> decodedOverviewPolylinePoints =
        polylinePoints.decodePolyline(encodedOverviewPolyline);

    // adding the coordinate to the list
    print("Checking if decoded polyline points is not empty.");
    if (decodedOverviewPolylinePoints.isNotEmpty) {
      print("adding polyline coordinate points to a list.");
      decodedOverviewPolylinePoints.forEach((PointLatLng point) {
        LatLng addPoint = LatLng(point.latitude, point.longitude);
        polylineCoordinates.add(addPoint);
      });
      print("Done adding polyline coordinate points to a list.");
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
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      // arguments = widget.arguments;
      // bounds = arguments["bounds"];
      // steps = arguments["steps"];
      // overviewPolyline = arguments["overviewPolyline"];
      // destinationLocation = arguments["destinationLocation"];
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
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
            buildingsEnabled: false,
            onMapCreated: (GoogleMapController controller) async {
              mapController = controller;
              await Future.delayed(Duration(seconds: 2));
              setState(() {
                arguments = widget.arguments;
                bounds = arguments["bounds"];
                steps = arguments["steps"];
                overviewPolyline = arguments["overviewPolyline"];
                destinationLocation = arguments["destinationLocation"];
              });
              _setRoute();
            },
          ),
        ],
      ),
    );
  }
}
