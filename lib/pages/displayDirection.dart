import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:research_mobile_app/request/mapRequest.dart';

class DisplayDirection extends StatefulWidget {
  const DisplayDirection({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;
  @override
  _DisplayDirectionState createState() => _DisplayDirectionState();
}

class _DisplayDirectionState extends State<DisplayDirection>
    with WidgetsBindingObserver {
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(8.2280, 124.2452), zoom: 12.0);

  late GoogleMapController mapController;
  late String travelMode;
  late String routeName;

  Location _trackUser = new Location();

  late PolylinePoints polylinePoints;
  Timer? timer;

  late String _mapStyle;
  bool waitingForResponse = false;
  StreamController _streamController = new StreamController<dynamic>();
  // Map storing polylines created by connecting two points
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  var arguments;
  var bounds;
  var steps;
  var overviewPolyline;
  var destinationLocation;

  void _setRoute({bool debug = false}) {
    if (debug) {
      print("Setting marker");
    }

    MarkerId markerId = MarkerId(destinationLocation.toString());
    Marker destinationMarker = Marker(
      markerId: markerId,
      position: destinationLocation,
      icon: BitmapDescriptor.defaultMarker,
    );

    // Add the markers to the list
    markers.add(destinationMarker);
    if (debug) {
      print("Done marker");
      print("Setting up camera bounds.");
    }

    double southWestLatitude = bounds["southwest"]["lat"];
    double southWestLongitude = bounds["southwest"]["lng"];

    double northEastLatitude = bounds["northeast"]["lat"];
    double northEastLongitude = bounds["northeast"]["lng"];
    if (debug) {
      print("Done camera bounds");
      print("Animating map camera.");
    }

    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
    if (debug) {
      print("Done animating");
      print("Drawing route");
    }

    // Draw route
    initPolyline(debug: debug);
  }

  void initPolyline({bool debug = false}) {
    // Object for PolylinePoints

    // List of coordinates to join
    List<LatLng> polylineCoordinates = [];
    // Initializing PolylinePoints

    print("Initializing polyline points.");
    polylinePoints = PolylinePoints();
    String encodedOverviewPolyline = overviewPolyline["points"];
    List<PointLatLng> decodedOverviewPolylinePoints =
        polylinePoints.decodePolyline(encodedOverviewPolyline);

    // adding the coordinate to the list
    if (debug) {
      print("Checking if decoded polyline points is not empty.");
    }

    if (decodedOverviewPolylinePoints.isNotEmpty) {
      if (debug) {
        print("adding polyline coordinate points to a list.");
      }

      decodedOverviewPolylinePoints.forEach((PointLatLng point) {
        LatLng addPoint = LatLng(point.latitude, point.longitude);
        polylineCoordinates.add(addPoint);
      });
      if (debug) {
        print("Done adding polyline coordinate points to a list.");
      }
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

  void updatePolyline({
    required String encodedPolyline,
    bool debug = false,
  }) {
    // List of coordinates to join
    List<LatLng> polylineCoordinates = [];

    print("Updating route");
    List<PointLatLng> decodedPolyline =
        polylinePoints.decodePolyline(encodedPolyline);
    if (debug) {
      print("Checking if decoded polyline points is not empty.");
    }

    if (decodedPolyline.isNotEmpty) {
      if (debug) {
        print("adding polyline coordinate points to a list.");
      }

      decodedPolyline.forEach((PointLatLng point) {
        LatLng addPoint = LatLng(point.latitude, point.longitude);
        polylineCoordinates.add(addPoint);
      });
      if (debug) {
        print("Done adding polyline coordinate points to a list.");
      }
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

    setState(() {
      polylines[polylineId] = polyline;
    });

    print("Done update");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    bool isBackground = state != AppLifecycleState.resumed;
    // startTimer(isBackground);
    print("isAppInBackground: $isBackground");
  }

  void startTimer() async {
    int delaySeconds = 10;
    print("Start timer.");

    // Cancelling previous timer, if there was one, and creating a new one
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: delaySeconds), (t) async {
      // Not sending a request, if waiting for response
      if (!waitingForResponse) {
        waitingForResponse = true;
        LocationData currentLocation = await _trackUser.getLocation();
        // print(
        //     "_curretUserPos: ${currentLocation.latitude} ${currentLocation.longitude}");

        LatLng myLocationPostion = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        var updatedRoute = await MapRequest().getRoute(
          origin: myLocationPostion,
          destination: destinationLocation,
        );
        var newRouteData = updatedRoute[routeName];
        updatePolyline(
          encodedPolyline: newRouteData["overview_polyline"]["points"],
        );
        // print(newRouteData);
        waitingForResponse = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String loadMapStyle = 'assets/default_mapStyle.txt';
    rootBundle.loadString(loadMapStyle).then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              mapController.setMapStyle(_mapStyle);
              await Future.delayed(Duration(seconds: 2));
              setState(() {
                arguments = widget.arguments;
                bounds = arguments["bounds"];
                steps = arguments["steps"];
                overviewPolyline = arguments["overviewPolyline"];
                destinationLocation = arguments["destinationLocation"];
                travelMode = steps[0]["travel_mode"];
                routeName = arguments["routeName"];
              });

              _setRoute();
              startTimer();
            },
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("Deactive display direction.");
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    print("Dispose display direction.");
    super.dispose();
  }
}
