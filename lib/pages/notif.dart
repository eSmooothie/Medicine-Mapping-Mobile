import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:research_mobile_app/models/notificationModel.dart';
import 'package:research_mobile_app/request/httpRequest.dart';
import 'package:research_mobile_app/request/requestNotif.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import '../exportHelper.dart';

class Notif extends StatefulWidget {
  const Notif({Key? key}) : super(key: key);

  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  String announcementPath = MyHttpRequest().serverUrl + "announcement/";

  @override
  void initState() {
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

    final storage = new FlutterSecureStorage();
    final bool isExist;
    int _ttlNotif = 0;
    if (result is List) {
      _ttlNotif = result.length;
    }
    isExist = await storage.containsKey(key: "notifCounter");
    if (isExist) {
      await storage.write(key: "notifCounter", value: _ttlNotif.toString());
    } else {
      await storage.write(key: "notifCounter", value: _ttlNotif.toString());
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Ink(
          child: InkWell(
            onTap: () {
              Navigator.popAndPushNamed(context, landingPage);
            },
            child: Icon(Icons.arrow_back),
          ),
        ),
        title: Text(
          "Notification",
        ),
      ),
      body: FutureBuilder(
          future: _getNotif(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<NotificationModel> _notif = snapshot.data;

              return ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    NotificationModel _notifData = _notif[index];
                    return Ink(
                      height: 50.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: InkWell(
                        onTap: () async {
                          String url = announcementPath + _notifData.ID;

                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  "${_notifData.TITLE}",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                  itemCount: _notif.length);
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
