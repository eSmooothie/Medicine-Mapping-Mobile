import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:research_mobile_app/models/notificationModel.dart';
import 'package:research_mobile_app/request/httpRequest.dart';
import 'package:research_mobile_app/request/requestNotif.dart';
import 'package:url_launcher/url_launcher.dart';

import '../exportHelper.dart';

class Notif extends StatefulWidget {
  const Notif({Key? key}) : super(key: key);

  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  String announcementPath = MyHttpRequest().serverUrl + "announcement/";
  late FlutterSecureStorage storage;
  @override
  void initState() {
    storage = new FlutterSecureStorage();
    super.initState();
  }

  @override
  void deactivate() {
    print("Deactivate notice page.");
    super.deactivate();
  }

  @override
  void dispose() {
    print("Dispose notice page.");

    super.dispose();
  }

  Future _getNotif() async {
    final result = await RequestNotification().getNotifications();

    final bool isExist;
    int _ttlNotif = 0;
    if (result is List) {
      _ttlNotif = result.length;
    }
    isExist = await storage.containsKey(key: "notif_counter");
    if (isExist) {
      await storage.write(key: "notif_counter", value: _ttlNotif.toString());
    } else {
      await storage.write(key: "notif_counter", value: _ttlNotif.toString());
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: HexColor("#A6DCEF"),
        title: Text(
          "Notification",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder(
          future: _getNotif(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<NotificationModel> _notif = snapshot.data;
              List<ListTile> _listTile = [];

              _notif.forEach((NotificationModel notification) {
                ListTile notificationTile = ListTile(
                  leading: Icon(Icons.campaign),
                  title: Text("${notification.TITLE}"),
                  subtitle: Text("${notification.CREATED_AT}"),
                  onTap: () async {
                    String url = announcementPath + notification.ID;

                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                );

                _listTile.add(notificationTile);
              });
              return SingleChildScrollView(
                child: Column(
                  children: _listTile,
                ),
              );
            } else if (snapshot.hasError) {
              // error encountered.
              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: CustomWidget.errorContainer(
                      errorMessage: snapshot.error.toString()),
                ),
              );
            }
            return Container();
          }),
    );
  }
}

// String url = announcementPath + _notifData.ID;

//                           if (await canLaunch(url)) {
//                             await launch(url);
//                           }