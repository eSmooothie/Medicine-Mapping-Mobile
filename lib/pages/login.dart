import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/helper/utilities.dart';
import 'package:research_mobile_app/models/pharmacy.dart';
import 'package:research_mobile_app/request/requestPatient.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.pharmacy}) : super(key: key);
  final Pharmacy pharmacy;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _phoneNumberController;
  late Pharmacy pharmacy;
  late FlutterSecureStorage storage;
  String? _phoneNumberErr;
  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    storage = FlutterSecureStorage();
    pharmacy = widget.pharmacy;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> checkStoredData() async {
    // check stored data

    final MyInformation _myInformation;
    final Map<String, String> _storedInfo;

    try {
      _storedInfo = await storage.readAll();
      if (_storedInfo.containsKey("user_nickname") &&
          _storedInfo.containsKey("user_phoneNumber")) {
        _myInformation = new MyInformation(
          nickname: _storedInfo['user_nickname']!,
          phoneNumber: _storedInfo['user_phoneNumber']!,
        );

        // check if exist in db
        Map<String, dynamic> data = {
          "phoneNumber": _myInformation.phoneNumber,
        };

        // send request
        Map<String, dynamic> result =
            await RequestPatient().getUserInfo(data: data);

        if (result.containsKey("phoneNumber")) {
          Future.delayed(Duration(seconds: 10));
          return true;
        }
        return false;
      }
    } catch (e) {
      storage.deleteAll();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: HexColor("#A6DCEF"),
        shadowColor: Colors.transparent,
      ),
      body: FutureBuilder(
        future: checkStoredData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              // redirect to chat
              SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                Navigator.popAndPushNamed(
                  context,
                  chatBoxPage,
                  arguments: pharmacy,
                );
              });
            }
            return SafeArea(
                child: Column(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    height: 200,
                    decoration: BoxDecoration(
                      color: HexColor("#A6DCEF"),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomWidget.textField(
                                prefixIcon: Icon(Icons.phone_android),
                                width: MediaQuery.of(context).size.width - 100,
                                controller: _phoneNumberController,
                                labelText: "Phone number",
                                hintText: "",
                                errorText: _phoneNumberErr,
                                keyboardType: TextInputType.number,
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    // validate
                                    setState(() {
                                      _phoneNumberErr =
                                          (_phoneNumberController.text == "")
                                              ? "Required"
                                              : null;
                                    });

                                    if (_phoneNumberController.text != "") {
                                      RegExp regExp =
                                          new RegExp(r"^(?:[+0]9)?[0-9]{9}$");
                                      if (!regExp.hasMatch(
                                          _phoneNumberController.text)) {
                                        setState(() {
                                          _phoneNumberErr =
                                              "Invalid phone number format.";
                                        });
                                      }
                                    }
                                    // check if exist
                                    if (_phoneNumberController.text != "" &&
                                        _phoneNumberErr == null) {
                                      Map<String, dynamic> sendData = {
                                        'phoneNumber':
                                            _phoneNumberController.text,
                                      };
                                      Map<String, dynamic> response =
                                          await RequestPatient()
                                              .getUserInfo(data: sendData);

                                      if (!response
                                          .containsKey("phoneNumber")) {
                                        setState(() {
                                          _phoneNumberErr =
                                              "Phone number does not exist.";
                                          _phoneNumberController.clear();
                                        });
                                      } else {
                                        storage.write(
                                          key: "user_nickname",
                                          value: response['nickname'],
                                        );
                                        storage.write(
                                          key: "user_phoneNumber",
                                          value: response['phoneNumber'],
                                        );

                                        Navigator.popAndPushNamed(
                                          context,
                                          chatBoxPage,
                                          arguments: pharmacy,
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    "Log in",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: HexColor("#A6DCEF"),
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width - 100,
                                      50,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, registerPage);
                                  },
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: HexColor("#C9E4C5"),
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width - 100,
                                      50,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: Utility.loadingCircular(),
            ),
          );
        },
      ),
    );
  }
}

class MyInformation {
  final String phoneNumber;
  final String nickname;

  MyInformation({
    required this.nickname,
    required this.phoneNumber,
  });
}
