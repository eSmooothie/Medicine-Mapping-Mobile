import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/exportRequest.dart';
import 'package:research_mobile_app/helper/showExitPopup.dart';
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
      CameraPosition(target: const LatLng(8.2280, 124.2452), zoom: 13.5);

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Location userLocationTracker = new Location();

  List<Pharmacy> pharmacies = [];
  bool isPermitted = false;
  bool viewPrice = false;
  bool isPharmacySelected = false;
  double pharmacyInfoBottomPosition = -400;
  double priceModalTopPosition = -100;
  double popUpMessageModal = -100;
  int numberOfPharmacyFound = 0;
  Pharmacy? selectedPharmacy;
  double? medicinePrice;

  double defaultZoom = 15;

  int pharmacyCounter = 0;

  Timer? timer;

  bool waitingForResponse = false;
  int timerCounter = 0;
  @override
  void initState() {
    medicine = widget.medicine;
    rootBundle.loadString('assets/default_mapStyle.txt').then((string) {
      mapStyle = string;
    });
    if (medicine != null) {
      setTimer();
    }
    super.initState();
  }

  void setTimer() async {
    // Cancelling previous timer, if there was one, and creating a new one
    timer?.cancel();

    timer = Timer.periodic(Duration(seconds: 3), (t) async {
      if (!waitingForResponse && timerCounter < 4) {
        waitingForResponse = true;
        print("timer: $timerCounter");
        setState(() {
          popUpMessageModal = 55;
          timerCounter += 1;
        });
        waitingForResponse = false;
      }
      if (timerCounter == 4) {
        setState(() {
          popUpMessageModal = -100;
          // timerCounter += 1;
        });
      }
    });
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
    super.dispose();
  }

  /// Map all the pharmacies
  ///
  /// Send a get request then map the returned data.
  /// Return either List of MedicinePharmacy or Pharmacy
  Future<void> getPharmacies() async {
    List<Object> result = [];
    List<Pharmacy> pharmacies = [];
    Map<String, double> prices = {};
    if (medicine != null) {
      result = await RequestMedicine().getPharmacies(
        id: medicine!.id,
      );
      result.forEach((Object data) {
        if (data is MedicinePharmacy && data.isStock) {
          pharmacies.add(data.pharmacy);
          prices[data.pharmacy.id] = data.price;
        }
      });

      numberOfPharmacyFound = result.length;
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
        price: (prices.isNotEmpty && prices.containsKey(pharmacy.id))
            ? prices[pharmacy.id]!
            : 0.0,
        position: pos,
      );
    });

    pharmacyCounter = pharmacies.length;
  }

  void _addMarker({
    required var id,
    required Pharmacy pharmacy,
    required double price,
    required LatLng position,
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

        setState(() {
          isPharmacySelected = true;
          selectedPharmacy = pharmacy;
          medicinePrice = price;
          pharmacyInfoBottomPosition = 1;
          priceModalTopPosition = (medicine != null) ? 50 : -100;
        });
      },
    );
    // add the new marker in the list.
    markers[markerId] = newMarker;
  }

  Widget _popUpMessage() {
    if (medicine == null) {
      return AnimatedPositioned(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        top: -1000,
        left: 1,
        right: 1,
        child: Container(),
      );
    }
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: popUpMessageModal,
      left: 1,
      right: 1,
      child: Align(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            children: [
              Text(
                "There are $pharmacyCounter pharmacies that sell ${medicine!.brandName}.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backgroundOverlay() {
    return Visibility(
      visible: isPharmacySelected,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withAlpha(920),
      ),
    );
  }

  Widget _medicineModalPrice() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      top: priceModalTopPosition,
      left: 1,
      right: 1,
      child: Align(
        child: Container(
          width: 300,
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Column(
            children: [
              Text(
                (medicine != null) ? "${medicine!.brandName}" : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                (medicinePrice != null)
                    ? "${medicinePrice!.toStringAsFixed(2)} PHP"
                    : "",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _gestureListener() {
    return Visibility(
      visible: isPharmacySelected,
      child: GestureDetector(
        onTap: () {
          double lat = double.parse(selectedPharmacy!.lat);
          double lng = double.parse(selectedPharmacy!.lng);
          LatLng pos = LatLng(lat, lng);
          //selectedPharmacy
          mapController
              .animateCamera((CameraUpdate.newCameraPosition(new CameraPosition(
            bearing: 0,
            target: pos,
            tilt: 0,
            zoom: defaultZoom,
          ))));
          setState(() {
            viewPrice = false;
            isPharmacySelected = false;
            pharmacyInfoBottomPosition = -400;
            priceModalTopPosition = -100;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.transparent,
        ),
      ),
    );
  }

  Widget _pharmacyInformation() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      bottom: pharmacyInfoBottomPosition,
      left: 1,
      right: 1,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
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
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        (selectedPharmacy != null)
                            ? "${selectedPharmacy!.name}"
                            : "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        (selectedPharmacy != null)
                            ? "${selectedPharmacy!.address}"
                            : "",
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
                      margin: EdgeInsets.only(bottom: 15.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white),
                          fixedSize: Size(175, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: () {
                          double lat = double.parse(selectedPharmacy!.lat);
                          double lng = double.parse(selectedPharmacy!.lng);
                          LatLng pos = LatLng(lat, lng);

                          Navigator.pushNamed(
                            context,
                            directionPage,
                            arguments: pos,
                          );
                        },
                        child: Text(
                          "Direction",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white),
                        fixedSize: Size(175, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          loginPage,
                          arguments: selectedPharmacy,
                        );
                      },
                      child: Text(
                        "Inquire",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leadingWidth: 150,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: Stack(children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) async {
              mapController = controller;
              mapController.setMapStyle(mapStyle);
              await getPharmacies();
              await _permissionLocation();
              if (medicine != null) {
                defaultZoom = 13.7;
                print("${medicine!.brandName}");
              }

              if (isPermitted) {
                LocationData loc = await userLocationTracker.getLocation();
                mapController.animateCamera(
                    (CameraUpdate.newCameraPosition(new CameraPosition(
                  bearing: 0,
                  target: LatLng(loc.latitude!, loc.longitude!),
                  tilt: 0,
                  zoom: defaultZoom,
                ))));
              }
            },
            compassEnabled: false,
            initialCameraPosition: initialCameraPosition,
            myLocationEnabled: isPermitted,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            markers: Set<Marker>.of(markers.values),
          ),
          _popUpMessage(),
          _backgroundOverlay(),
          _gestureListener(),
          _medicineModalPrice(),
          _pharmacyInformation(),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              landingPage,
            );
          },
          child: Icon(Icons.search),
          backgroundColor: HexColor("#F46060"),
        ),
      ),
    );
  }
}
