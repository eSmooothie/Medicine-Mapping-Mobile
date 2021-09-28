import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import '../helper/googleMap.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/exportRequest.dart';
import 'package:research_mobile_app/models/pharmacy.dart';

class LandingPage extends StatefulWidget {
  final String title;
  const LandingPage({Key? key, required this.title}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late GoogleMapController mapController;
  late String _mapStyle;
  late bool _serviceEnabled;

  late PermissionStatus _permissionGranted;
  final LatLng _center = const LatLng(8.2280, 124.2452);

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<CircleId, Circle> _circles = <CircleId, Circle>{};
  Location _userLocationTracker = new Location();
  bool darkMode = false;
  bool _isPermitted = false;
  double _zoom = 13.0;

  @override
  void initState() {
    _permissionLocation();
    _initPharmacy(); // init pharmacy
    // load google map style
    String loadMapStyle =
        darkMode ? 'assets/dark_mapStyle.txt' : 'assets/default_mapStyle.txt';
    rootBundle.loadString(loadMapStyle).then((string) {
      _mapStyle = string;
    });

    super.initState();
  }

  // ask permission to access the location of the user
  Future _permissionLocation() async {
    bool isPermitted = await _checkLocationService();

    if (!isPermitted) {
      // if not permitted throw error
      throw Exception(
          "Enable to load the map please do allow the application to access your location. Thank you.");
    }

    setState(() {
      _isPermitted = isPermitted;
    });
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

  // initialize pharmacy
  void _initPharmacy() {
    print("Request Pharmacy location");
    RequestPharmacy().QueryAll().then((pharmacies) {
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
      setState(() {});
    });
    // wait for permission to be granted
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Color.fromARGB(255, 41, 171, 226),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) async {
          mapController = controller;
          _permissionLocation();
          mapController.setMapStyle(_mapStyle);

          if (_isPermitted) {
            LocationData loc = await _userLocationTracker.getLocation();
            mapController.animateCamera(
                CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 0,
              target: LatLng(loc.latitude!, loc.longitude!),
              tilt: 0,
              zoom: 15.00,
            )));
          }
        },
        myLocationEnabled: _isPermitted,
        myLocationButtonEnabled: false,
        initialCameraPosition: CameraPosition(target: _center, zoom: _zoom),
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        markers: Set<Marker>.of(_markers.values),
        circles: Set<Circle>.of(_circles.values),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.search_ellipsis,
        overlayColor: Color.fromARGB(255, 41, 171, 226),
        backgroundColor: Color.fromARGB(255, 255, 108, 85),
        animationSpeed: 50,
        spacing: 10.0,
        spaceBetweenChildren: 10.0,
        children: [
          SpeedDialChild(
            child: SizedBox(
              height: 25,
              width: 25,
              child: SvgIcons.capsulesSolid,
            ),
            label: "Medicine",
            onTap: () {
              List<Object> args = [
                "medicine",
              ];
              Navigator.popAndPushNamed(context, searchPage, arguments: args);
            },
          ),
          SpeedDialChild(
            child: SizedBox(
              height: 25,
              width: 25,
              child: SvgIcons.pharmacy,
            ),
            label: "Pharmacy",
            onTap: () {
              List<Object> args = [
                "pharmacy",
              ];
              Navigator.popAndPushNamed(context, searchPage, arguments: args);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      extendBodyBehindAppBar: true,
    );
  }

  @override
  void deactivate() {
    print("Deactivate landing page");
    super.deactivate();
  }

  @override
  void dispose() {
    print("Dispose landing page");

    try {
      mapController.dispose();
    } catch (e) {}

    super.dispose();
  }
}
