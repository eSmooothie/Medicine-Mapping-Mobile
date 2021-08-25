import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:research_mobile_app/exportHelper.dart';

class Notice extends StatefulWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  _NoticeState createState() => _NoticeState();
}

class _NoticeState extends State<Notice> {
  final storage = new FlutterSecureStorage();
  final options = IOSOptions(accessibility: IOSAccessibility.first_unlock);

  @override
  void initState() {
    super.initState();
    checkReadStorage();
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

  // check if the user done reading this page
  // and click the understand button
  void checkReadStorage() async {
    bool doneReading = await storage.containsKey(key: "doneReadingNotice");
    // print(doneReading);
    if (doneReading) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.popAndPushNamed(
          context,
          landingPage,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomWidget.outlinedButton(
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              landingPage,
            );
          },
          child: Icon(
            Icons.close,
            color: Colors.white,
          ),
          side: BorderSide.none,
        ),
        title: Text("Read Me"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("X"),
              Text("y"),
              SizedBox(
                height: 150,
              )
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width,
              child: CustomWidget.outlinedButton(
                  onPressed: () {
                    print("Writing key `doneReadingNotice` in storage");
                    storage.write(key: "doneReadingNotice", value: "1");
                  },
                  child: Text(
                    "I understand",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
