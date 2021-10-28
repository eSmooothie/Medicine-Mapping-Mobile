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
  Future<bool> checkReadStorage() async {
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

    return doneReading;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkReadStorage(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return Scaffold();
            }
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Disclaimer:",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: Text(
                            "First and foremost, we, the developers of project med-mapping would like to extend our deepest gratitude " +
                                "and sincerity in showing the \"interest\" in participating the alpha test.",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Withforth, the developers would like to let you know the following:",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "1. The application is still under construction and is still subject " +
                                "to change, readdress errors & bugs.",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "2. The inventory system of the named pharmacy are dummy created and " +
                                "does not represent the pharmacy itself.",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "3. Not all medicines are listed here as the developers lack " +
                                "sufficient expertise in handling critical medicinal information.",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "4. There will be a follow-up questionnaire given after testing " +
                                "out the application.",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20.0),
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "5. Participants can withdraw their participation without question " +
                                "at any time anywhere.",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: Text(
                            "As a participant of the alpha-test, the developers would like a " +
                                "complete and honest reaction of experiencing project med-mapping as " +
                                "part of term no.4, as this will help the developers improved, investigated, " +
                                "readdress errors & bugs not seen during pre-project commencing test. ",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Project med-mapping consists of two(2) applications with three(3) " +
                                "main informations to collect; as for the patient; first name, last name " +
                                "and phone number. Pharmacy; geographical information (latitude and longtitude), " +
                                "name, contact detail, scanned certificates and address. as for pharmacists; " +
                                "first name, last name, contact details, address.",
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 15.0),
                          child: Text(
                            "Nevertheless, the developers of project med-mapping, do guarantee that all data " +
                                "collected, sensitive and personal information will and will be remained " +
                                "confidential.",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "By clicking, \"I agree\" serves as your confirmation to voluntarily " +
                                "volunteer in the alpha testing of project med-mapping and have already " +
                                "read and understand the terms and conditions written above.",
                            style: TextStyle(
                              fontSize: 14.0,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
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
                                  print(
                                      "Writing key `doneReadingNotice` in storage");
                                  storage.write(
                                      key: "doneReadingNotice", value: "1");
                                  Navigator.popAndPushNamed(
                                    context,
                                    landingPage,
                                  );
                                },
                                child: Text(
                                  "I agree",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {}

          return Container();
        });
  }
}
