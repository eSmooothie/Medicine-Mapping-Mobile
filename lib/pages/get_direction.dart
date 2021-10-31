import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:research_mobile_app/exportRequest.dart';

class GetDirection extends StatefulWidget {
  const GetDirection({
    Key? key,
    required this.pharmacyLocation,
  }) : super(key: key);
  final LatLng pharmacyLocation;
  @override
  _GetDirectionState createState() => _GetDirectionState();
}

class _GetDirectionState extends State<GetDirection> {
  late GoogleMapController mapController;
  late PolylinePoints polylinePoints;
  late String mapStyle;
  late LatLng pharmacyLocation;
  late Marker pharmacyMarker;

  Location trackUser = new Location();

  CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(8.2280, 124.2452), zoom: 14.0);

  Timer? timer;
  Path? currentPath;
  Path? previousPath;
  List<Path> paths = [];
  Map<PolylineId, Polyline> polylines = {};
  bool waitingForResponse = false;

  @override
  void initState() {
    pharmacyLocation = widget.pharmacyLocation;
    rootBundle.loadString('assets/default_mapStyle.txt').then((string) {
      mapStyle = string;
    });
    pharmacyMarker = Marker(
      markerId: MarkerId("destination"),
      position: pharmacyLocation,
    );
    super.initState();
  }

  @override
  void deactivate() {
    timer?.cancel();
    super.deactivate();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  /// Get all possible routes given user location
  /// to pharmacy's location.
  Future possibleRoutes() async {
    LocationData myLocationData = await trackUser.getLocation();
    LatLng origin = LatLng(myLocationData.latitude!, myLocationData.longitude!);
    Map<String, dynamic> walkingRoute = {};
    Map<String, dynamic> drivingRoute = {};
    List<Path> routes = [];
    walkingRoute = await MapRequest().getRoute(
      origin: origin,
      destination: pharmacyLocation,
      mode: "walking",
    );
    drivingRoute = await MapRequest().getRoute(
      origin: origin,
      destination: pharmacyLocation,
      mode: "driving",
    );

    walkingRoute.remove("start_address");
    drivingRoute.remove("start_address");

    drivingRoute.forEach((key, value) {
      String name = key;
      String distance = value["distance"]["text"];
      String time = value["duration"]["text"];
      String overviewPolyline = value["overview_polyline"]["points"];

      double northeastLat = value["bounds"]["northeast"]["lat"];
      double northeastLng = value["bounds"]["northeast"]["lng"];
      LatLng northeast = LatLng(northeastLat, northeastLng);

      double southwestLat = value["bounds"]["southwest"]["lat"];
      double southwestLng = value["bounds"]["southwest"]["lng"];
      LatLng southwest = LatLng(southwestLat, southwestLng);

      Path newPath = Path(
        mode: "driving",
        name: name,
        distance: distance,
        time: time,
        overviewPolyline: overviewPolyline,
        northeast: northeast,
        southwest: southwest,
        info: value,
      );

      routes.add(newPath);
    });

    walkingRoute.forEach((key, value) {
      String name = key;
      String distance = value["distance"]["text"];
      String time = value["duration"]["text"];
      String overviewPolyline = value["overview_polyline"]["points"];

      double northeastLat = value["bounds"]["northeast"]["lat"];
      double northeastLng = value["bounds"]["northeast"]["lng"];
      LatLng northeast = LatLng(northeastLat, northeastLng);

      double southwestLat = value["bounds"]["southwest"]["lat"];
      double southwestLng = value["bounds"]["southwest"]["lng"];
      LatLng southwest = LatLng(southwestLat, southwestLng);

      Path newPath = Path(
        mode: "walking",
        name: name,
        distance: distance,
        time: time,
        overviewPolyline: overviewPolyline,
        northeast: northeast,
        southwest: southwest,
        info: value,
      );

      routes.add(newPath);
    });

    if (currentPath == null) {
      // set the first path instance as the initial route
      currentPath = routes[0];
      previousPath = routes[0];
    } else {
      // upon update, check for matching transport mode and name
      bool doneUpdate = false;
      routes.forEach((Path path) {
        if (path.mode == currentPath!.mode &&
            path.name == currentPath!.name &&
            !doneUpdate) {
          doneUpdate = true;
          currentPath = path;
        }
      });
      // check other route w/ match transport mode
      routes.forEach((Path path) {
        if (path.mode == currentPath!.mode && !doneUpdate) {
          doneUpdate = true;
          currentPath = path;
        }
      });
    }

    paths = routes;

    setState(() {});
  }

  List<ListTile> generateListTile() {
    List<ListTile> route = [];
    paths.forEach((Path path) {
      ListTile listTile = ListTile(
        selected: (path == currentPath) ? true : false,
        leading: (path.mode == "walking")
            ? Icon(FontAwesomeIcons.walking)
            : Icon(FontAwesomeIcons.car),
        title: Text("${path.name}"),
        subtitle: Text("Duration: ${path.time} Distance: ${path.distance}"),
        onTap: () {
          updateDrawing(encodedPolyline: path.overviewPolyline);
          setState(() {
            previousPath = currentPath;
            currentPath = path;
          });
          print("${path.name}");
        },
      );

      route.add(listTile);
    });

    return route;
  }

  Future drawRoute() async {
    // animate map camera based on currentPath bound
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: currentPath!.northeast,
          southwest: currentPath!.southwest,
        ),
        100.0,
      ),
    );
    // init polylinespoints
    polylinePoints = PolylinePoints();
    // List of coordinates to join
    List<LatLng> polylineCoordinates = [];
    String encodedOverviewPolyline = currentPath!.overviewPolyline;
    List<PointLatLng> decodedOverviewPolylinePoints =
        polylinePoints.decodePolyline(encodedOverviewPolyline);

    if (decodedOverviewPolylinePoints.isNotEmpty) {
      // adding polyline coordinate points to a the list.
      decodedOverviewPolylinePoints.forEach((PointLatLng point) {
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
  }

  void updateDrawing({required String encodedPolyline}) {
    // animate map camera based on currentPath bound
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: currentPath!.northeast,
          southwest: currentPath!.southwest,
        ),
        100.0,
      ),
    );
    // List of coordinates to join
    List<LatLng> polylineCoordinates = [];
    // decode encodedPolyline
    List<PointLatLng> decodedPolyline =
        polylinePoints.decodePolyline(encodedPolyline);

    if (decodedPolyline.isNotEmpty) {
      // adding polylines coordinate points to a list.
      decodedPolyline.forEach((PointLatLng point) {
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

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  Future startTimer() async {
    int delaySeconds = 5;

    // Cancelling previous timer, if there was one, and creating a new one
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: delaySeconds), (t) async {
      // Not sending a request, if waiting for response
      if (!waitingForResponse) {
        waitingForResponse = true;
        // get user curret location
        await possibleRoutes();
        updateDrawing(encodedPolyline: currentPath!.overviewPolyline);

        waitingForResponse = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: HexColor("#A6DCEF"),
        title: Text(
          "Route",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) async {
                mapController = controller;
                mapController.setMapStyle(mapStyle);

                await possibleRoutes();
                await drawRoute();
                await startTimer();
              },
              initialCameraPosition: initialCameraPosition,
              myLocationEnabled: true,
              indoorViewEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: false,
              buildingsEnabled: false,
              markers: {pharmacyMarker},
              polylines: Set<Polyline>.of(polylines.values),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Suggested Routes",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: generateListTile(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Path {
  final String mode;
  final String name;
  final String distance;
  final String time;
  final String overviewPolyline;
  final LatLng northeast;
  final LatLng southwest;
  final Map<String, dynamic> info;

  Path({
    required this.mode,
    required this.name,
    required this.distance,
    required this.time,
    required this.overviewPolyline,
    required this.northeast,
    required this.southwest,
    required this.info,
  });
}
