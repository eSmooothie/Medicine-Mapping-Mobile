import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../helper/googleMap.dart';
import 'package:research_mobile_app/exportHelper.dart';

class LandingPage extends StatefulWidget {
  final String title;
  const LandingPage({Key? key, required this.title}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Gmap map;

  @override
  Widget build(BuildContext context) {
    map = Gmap(context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: map.initMap(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            // done waiting
            return snapshot.data!;
          } else if (snapshot.hasError) {
            // error
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ];
          } else {
            // waiting
            children =
                Utility.loadingCircular(loadingLabel: "Loading google map...");
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.search_ellipsis,
        overlayColor: Colors.blue.shade100,
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
    // TODO: implement deactivate
    print("Deactivate landing page");
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    map.dispose();

    super.dispose();
  }
}
