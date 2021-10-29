import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/exportRequest.dart';
import 'package:research_mobile_app/models/medicine.dart';
import 'package:research_mobile_app/models/medicinePharmacy.dart';
import 'package:research_mobile_app/models/pharmacy.dart';
import 'package:research_mobile_app/request/requestMedicine.dart';

class MyMap extends StatefulWidget {
  const MyMap({Key? key, this.medicine}) : super(key: key);
  final Medicine? medicine;
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late GoogleMapController mapController;
  late String mapStyle;
  late bool serviceEnabled;
  late PermissionStatus permissionGranted;
  late Medicine? medicine;

  final LatLng mapStartingPoint = const LatLng(8.2280, 124.2452);
  final CameraPosition initialCameraPosition =
      CameraPosition(target: const LatLng(8.2280, 124.2452), zoom: 13.0);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Location userLocationTracker = new Location();

  List<Pharmacy> pharmacies = [];
  bool isPermitted = false;

  @override
  void initState() {
    medicine = widget.medicine;
    rootBundle.loadString('assets/default_mapStyle.txt').then((string) {
      mapStyle = string;
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
      this.isPermitted = isPermitted;
    });
  }

  Future<bool> _checkLocationService() async {
    serviceEnabled = await userLocationTracker.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await userLocationTracker.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    permissionGranted = await userLocationTracker.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await userLocationTracker.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  /// Map all the pharmacies
  ///
  /// Send a get request then map the returned data.
  /// Return either List of MedicinePharmacy or Pharmacy
  Future<List<Object>> getPharmacies() async {
    List<Object> result = [];
    List<Pharmacy> pharmacies = [];
    if (medicine != null) {
      result = await RequestMedicine().getPharmacies(
        id: medicine!.id,
      );
      result.forEach((Object data) {
        if (data is MedicinePharmacy && data.isStock) {
          pharmacies.add(data.pharmacy);
        }
      });
    } else if (medicine == null) {
      result = await RequestPharmacy().QueryAll();
      result.forEach((Object data) {
        if (data is Pharmacy) {
          pharmacies.add(data);
        }
      });
    }

    pharmacies.forEach((Pharmacy pharmacy) {
      double lat = double.parse(pharmacy.lat);
      double lng = double.parse(pharmacy.lng);
      LatLng pos = LatLng(lat, lng);
      _addMarker(
          id: pharmacy.id,
          pharmacy: pharmacy,
          position: pos,
          onPressedDirection: () {
            print("direction");

            Navigator.pushNamed(
              context,
              directionPage,
              arguments: pos,
            );
          },
          onPressedInquire: () {
            print("inquire");
          });
    });

    return result;
  }

  void _addMarker({
    required var id,
    required Pharmacy pharmacy,
    required LatLng position,
    required void Function()? onPressedDirection,
    required void Function()? onPressedInquire,
  }) {
    MarkerId markerId = MarkerId(id.toString());
    final Marker newMarker = Marker(
      markerId: markerId,
      position: position,
      onTap: () async {
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
          bearing: 0,
          target: position,
          tilt: 0,
          zoom: 18.00,
        )));

        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return Container(
              height: 250,
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "${pharmacy.name}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "${pharmacy.address}",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white),
                              fixedSize: Size(100, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            onPressed: onPressedDirection,
                            child: Text(
                              "Direction",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white),
                            fixedSize: Size(100, 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          onPressed: onPressedInquire,
                          child: Text(
                            "Inquire",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
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
    markers[markerId] = newMarker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: 150,
        leading: OutlinedButton.icon(
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              landingPage,
            );
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide.none,
          ),
          icon: Icon(
            Icons.search,
          ),
          label: Text("Search Medicine"),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: getPharmacies(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return GoogleMap(
            onMapCreated: (GoogleMapController controller) async {
              mapController = controller;
              mapController.setMapStyle(mapStyle);

              await _permissionLocation();
              if (medicine != null) {
                print("${medicine!.brandName}");
              }

              if (isPermitted) {
                LocationData loc = await userLocationTracker.getLocation();
                mapController.animateCamera(
                    CameraUpdate.newCameraPosition(new CameraPosition(
                  bearing: 0,
                  target: LatLng(loc.latitude!, loc.longitude!),
                  tilt: 0,
                  zoom: 15.00,
                )));
                LatLng myDistance = LatLng(loc.latitude!, loc.longitude!);
              }
            },
            initialCameraPosition: initialCameraPosition,
            myLocationEnabled: isPermitted,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: Set<Marker>.of(markers.values),
          );
        },
      ),
    );
  }
}
