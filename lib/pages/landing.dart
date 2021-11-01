import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:location/location.dart';
import 'package:research_mobile_app/exportModel.dart';
import 'package:research_mobile_app/exportRequest.dart';
import 'package:research_mobile_app/helper/newLoading.dart';
import 'package:research_mobile_app/helper/showExitPopup.dart';
import 'package:research_mobile_app/pages/searchWidget.dart';
import 'package:research_mobile_app/request/requestNotif.dart';
import 'package:search_choices/search_choices.dart';

import '../exportHelper.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  TextEditingController searchMedicineController = TextEditingController();

  late bool _serviceEnabled;
  late FlutterSecureStorage storage;
  late PermissionStatus _permissionGranted;
  Location _userLocationTracker = new Location();
  bool _newNotification = false;

  @override
  void initState() {
    storage = FlutterSecureStorage();
    _permissionLocation();

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

  Future<void> _checkNotification() async {
    var notif = await RequestNotification().getNotifications();
    int _ttlNotfication = 0;

    if (notif is List) {
      _ttlNotfication = notif.length;
    }

    bool isExist = await storage.containsKey(key: "notif_counter");

    if (isExist) {
      String? _storedValue = await storage.read(key: "notif_counter");
      int _lastCount = int.parse(_storedValue!);
      // check if total notif is match to the last count
      if (_ttlNotfication > _lastCount) {
        // get the number of new notification

        setState(() {
          _newNotification = true;
        });
      }
    } else {
      setState(() {
        _newNotification = true;
      });

      await storage.write(key: "notif_counter", value: "0");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Get all medicine in the database, by sending
  /// a get request
  Future get_all_medicine() async {
    var data = await RequestMedicine().QueryAll();
    await _checkNotification();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          foregroundColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "Medicine Mapping",
            style: TextStyle(
              color: Colors.blueAccent,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, notifPage);
              },
              icon: Stack(children: [
                Icon(Icons.notifications_outlined),
                Align(
                  alignment: Alignment.topLeft,
                  child: Visibility(
                    visible: _newNotification,
                    child: Container(
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                )
              ]),
              color: Colors.blueAccent,
            )
          ],
        ),
        body: FutureBuilder(
          future: get_all_medicine(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<DropdownMenuItem<String>> _drugs = [];

              if (snapshot.data is List<Medicine>) {
                snapshot.data.forEach((Medicine drug) {
                  String drugName = (drug.brandName.isEmpty)
                      ? drug.genericNames.toString()
                      : drug.brandName;

                  DropdownMenuItem<String> item = DropdownMenuItem(
                    key: Key(drug.id),
                    value: drugName,
                    child: Text(
                      "$drugName",
                      overflow: TextOverflow.ellipsis,
                    ),
                  );

                  _drugs.add(item);
                });
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Flex(direction: Axis.vertical, children: [
                        SearchWidget(
                          medicines: snapshot.data,
                          controller: searchMedicineController,
                        ),
                      ]),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 50.0),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.popAndPushNamed(
                            context,
                            mapPage,
                          );
                        },
                        icon: Icon(
                          FontAwesomeIcons.mapMarkedAlt,
                          size: 35,
                        ),
                        label: Container(
                          margin: EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: Text(
                            "Map",
                            style: TextStyle(
                              fontSize: 18.0,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: Utility.loadingCircular(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
