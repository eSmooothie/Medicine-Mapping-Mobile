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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Gmap(),
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
    print("Deactivate landing page");
    super.deactivate();
  }

  @override
  void dispose() {
    print("Dispose landing page");

    super.dispose();
  }
}
