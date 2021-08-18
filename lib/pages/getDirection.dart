import 'package:flutter/material.dart';
import 'package:research_mobile_app/exports.dart';

class GetDirection extends StatefulWidget {
  const GetDirection({Key? key}) : super(key: key);

  @override
  _GetDirectionState createState() => _GetDirectionState();
}

class _GetDirectionState extends State<GetDirection> {
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
                                "current location",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
                                "destination location",
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
                                print("WALK");
                              },
                              child: Text("WALK"),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            child: CustomWidget.outlinedButton(
                              onPressed: () {
                                print("BICYCLE");
                              },
                              child: Text("BICYCLE"),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            child: CustomWidget.outlinedButton(
                              onPressed: () {
                                print("CAR");
                              },
                              child: Text(
                                "CAR",
                              ),
                              backgroundColor: Colors.white,
                              side: BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
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
                            "+12",
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
                  StreamBuilder(
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Ink(
                        padding: EdgeInsets.only(left: 25.0),
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.blue.withAlpha(50),
                            border: Border.all(
                              color: Colors.blue,
                            )),
                        child: InkWell(
                          onTap: () {
                            print("Route tap.");
                          },
                          child: Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Route name
                              Text(
                                "Route name",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Arrival time
                              Text(
                                "Arrival Time: XX:XX AM/PM",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("Deactive get direction page.");
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("Dispose get direction.");
    super.dispose();
  }
}
