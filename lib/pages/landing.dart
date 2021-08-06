import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../helper/googleMap.dart';
import 'package:research_mobile_app/exports.dart';

class LandingPage extends StatefulWidget {
  final String title;
  const LandingPage({Key? key, required this.title}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
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
      body: Map().initMap(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.search_ellipsis,
        overlayColor: Colors.transparent,
        spacing: 10.0,
        spaceBetweenChildren: 10.0,
        children: [
          SpeedDialChild(
            child: SizedBox(
              height: 25,
              width: 25,
              child: SvgIcons.capsules_solid,
            ),
            label: "Medicine",
          ),
          SpeedDialChild(
            child: SizedBox(
              height: 25,
              width: 25,
              child: SvgIcons.pharmacy,
            ),
            label: "Pharmacy",
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      extendBodyBehindAppBar: true,
    );
  }
}
