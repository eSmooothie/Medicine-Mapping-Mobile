import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Future _myData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Information"),
      ),
      body: FutureBuilder(
        future: _myData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Text("Hi");
        },
      ),
    );
  }
}
