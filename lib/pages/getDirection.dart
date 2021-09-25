import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/request/mapRequest.dart';

class GetDirection extends StatefulWidget {
  const GetDirection({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;
  @override
  _GetDirectionState createState() => _GetDirectionState();
}

class _GetDirectionState extends State<GetDirection> {
  Location location = new Location();
  late var args;
  late LatLng destinationLoc;
  late String destinationAddress;
  int travelMode = 0;
  int totalRoute = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      args = widget.arguments;
      destinationLoc = args[0];
      destinationAddress = args[1];
    });
  }

  Future _routeFuture() async {
    LocationData myLocationData = await location.getLocation();
    LatLng origin = LatLng(myLocationData.latitude!, myLocationData.longitude!);

    var walkData = await MapRequest().getRoute(
      origin: origin,
      destination: destinationLoc,
      mode: "walking",
    );
    var driveData = await MapRequest().getRoute(
      origin: origin,
      destination: destinationLoc,
      mode: "driving",
    );
    var bicycleData = await MapRequest().getRoute(
      origin: origin,
      destination: destinationLoc,
      mode: "bicycling",
    );

    List<dynamic> allModeRoute = [
      walkData, // 0
      bicycleData, // 1
      driveData, // 2
      walkData["start_address"],
    ];

    return allModeRoute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomWidget.outlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          minHeight: 50.0,
          minWidth: 50.0,
          side: BorderSide(color: Colors.transparent),
        ),
        title: Text("Map"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // get direction
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 100,
                    padding: EdgeInsets.only(left: 25.0),
                    child: Text(
                      "Get Direction",
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  // routes
                  FutureBuilder(
                    future: _routeFuture(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      String from = "start_add";
                      List<dynamic> snapshotData = [];

                      if (snapshot.hasData) {
                        snapshotData = snapshot.data;
                        from = snapshotData[3];

                        return Flex(
                          direction: Axis.vertical,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // from and to
                            Container(
                              height: 170,
                              padding: EdgeInsets.only(left: 25.0),
                              child: Flex(
                                direction: Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "From:",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          "$from",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "To:",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Text(
                                          "$destinationAddress",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // buttons
                            Container(
                              height: 100,
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(15.0),
                                      child: CustomWidget.outlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            travelMode = 0;

                                            print("mode:$travelMode");
                                          });
                                        },
                                        child: Flex(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          direction: Axis.horizontal,
                                          children: [
                                            Icon(
                                              Icons.directions_walk_rounded,
                                              color: (travelMode == 0)
                                                  ? Colors.greenAccent.shade700
                                                  : Colors.blue,
                                            ),
                                            Text(
                                              "WALK",
                                              style: TextStyle(
                                                color: (travelMode == 0)
                                                    ? Colors
                                                        .greenAccent.shade700
                                                    : Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color: (travelMode == 0)
                                              ? Colors.greenAccent.shade700
                                              : Colors.blue,
                                          width: 2.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      child: CustomWidget.outlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            travelMode = 1;

                                            print("mode:$travelMode");
                                          });
                                        },
                                        child: Flex(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          direction: Axis.horizontal,
                                          children: [
                                            Icon(
                                              Icons.directions_bike_rounded,
                                              color: (travelMode == 1)
                                                  ? Colors.greenAccent.shade700
                                                  : Colors.blue,
                                            ),
                                            Text("  BICYCLE",
                                                style: TextStyle(
                                                  color: (travelMode == 1)
                                                      ? Colors
                                                          .greenAccent.shade700
                                                      : Colors.blue,
                                                )),
                                          ],
                                        ),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color: (travelMode == 1)
                                              ? Colors.greenAccent.shade700
                                              : Colors.blue,
                                          width: 2.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(15.0),
                                      child: CustomWidget.outlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            travelMode = 2;

                                            print("mode:$travelMode ");
                                          });
                                        },
                                        child: Flex(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          direction: Axis.horizontal,
                                          children: [
                                            Icon(
                                              Icons.directions_car_rounded,
                                              color: (travelMode == 2)
                                                  ? Colors.greenAccent.shade700
                                                  : Colors.blue,
                                            ),
                                            Text(
                                              " CAR",
                                              style: TextStyle(
                                                color: (travelMode == 2)
                                                    ? Colors
                                                        .greenAccent.shade700
                                                    : Colors.blue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                          color: (travelMode == 2)
                                              ? Colors.greenAccent.shade700
                                              : Colors.blue,
                                          width: 2.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // suggested route
                            Container(
                              height: 50.0,
                              padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      "Suggested Route",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   flex: 1,
                                  //   child: Text(
                                  //     (totalRoute > 0) ? "+$totalRoute" : "0",
                                  //     // "",
                                  //     style: TextStyle(
                                  //       color: Colors.blue,
                                  //       fontSize: 18.0,
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            // routes
                            Flex(
                              direction: Axis.vertical,
                              children:
                                  routeHolder(data: snapshotData[travelMode]),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: CustomWidget.errorContainer(
                              errorMessage: snapshot.error.toString(),
                            ),
                          ),
                        );
                      }
                      return Flex(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // from and to
                          Container(
                            height: 170,
                            padding: EdgeInsets.only(left: 25.0),
                            child: Flex(
                              direction: Axis.vertical,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "From:",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: SkeletonContainer.square(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "To:",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          child: SkeletonContainer.square(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 25,
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // buttons
                          Container(
                            height: 100,
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(15.0),
                                    child: CustomWidget.outlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          print("mode:$travelMode");
                                          travelMode = 0;
                                          print("mode:$travelMode");
                                        });
                                      },
                                      child: Text("WALK"),
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Colors.blue),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(15.0),
                                    child: CustomWidget.outlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          print("mode:$travelMode");
                                          travelMode = 1;
                                          print("mode:$travelMode");
                                        });
                                      },
                                      child: Text(
                                        "BICYCLE",
                                      ),
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Colors.blue),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(15.0),
                                    child: CustomWidget.outlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          print("mode:$travelMode");
                                          travelMode = 2;
                                          print("mode:$travelMode");
                                        });
                                      },
                                      child: Text(
                                        "CAR",
                                      ),
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Colors.blue),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // suggested route
                          Container(
                            height: 50.0,
                            padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "Suggested Route",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // routes
                          Flex(
                            direction: Axis.vertical,
                            children: [
                              SkeletonContainer.square(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> routeHolder({Map? data}) {
    List<Widget> listWidget = [];
    data!.remove("start_address");
    data.forEach((key, value) {
      // print("$key:$value");
      Widget widget = Ink(
        padding: EdgeInsets.only(left: 25.0),
        height: 100,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.blue.withAlpha(50),
            border: Border.all(
              color: Colors.blue,
            )),
        child: InkWell(
          onTap: () {
            print("Route tap.");
            Map<String, dynamic> args = {
              "routeName": key,
              "bounds": value["bounds"],
              "steps": value["steps"],
              "overviewPolyline": value["overview_polyline"],
              "destinationLocation": destinationLoc,
              "destinationAddress": destinationAddress,
              "destinationTime": value["duration"]["text"],
              "destinationDistance": value["distance"]["text"]
            };
            Navigator.pushNamed(
              context,
              displayDirectionPage,
              arguments: args,
            );
          },
          child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Route name
              Text(
                "$key",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Arrival time
              Text(
                "Distance: ${value["distance"]["text"]}\nDuration: ${value["duration"]["text"]}",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      );

      listWidget.add(widget);
    });

    return listWidget;
  }

  @override
  void deactivate() {
    print("Deactive get direction page.");
    super.deactivate();
  }

  @override
  void dispose() {
    print("Dispose get direction.");
    super.dispose();
  }
}
