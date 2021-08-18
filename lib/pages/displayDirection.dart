import 'package:flutter/material.dart';

class DisplayDirection extends StatefulWidget {
  const DisplayDirection({Key? key}) : super(key: key);

  @override
  _DisplayDirectionState createState() => _DisplayDirectionState();
}

class _DisplayDirectionState extends State<DisplayDirection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: Text("Display selected route"),
    );
  }
}
