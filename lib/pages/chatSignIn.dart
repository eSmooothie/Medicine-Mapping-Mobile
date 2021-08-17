import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:research_mobile_app/exports.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? _phoneNumberErr;
  String? _passwordErr;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passswordController = TextEditingController();

  Future _future = Future(() async {
    final storage = new FlutterSecureStorage();
    final options = IOSOptions(accessibility: IOSAccessibility.first_unlock);
    final AccountInfo _accountInfo;
    final Map<String, String> _storedInfo;
    // check if credential is stored in the local storage.
    try {
      _storedInfo = await storage.readAll();
      if (_storedInfo.containsKey("id") &&
          _storedInfo.containsKey("firstName") &&
          _storedInfo.containsKey("lastName") &&
          _storedInfo.containsKey("password") &&
          _storedInfo.containsKey("phoneNumber")) {
        _accountInfo = new AccountInfo(
            id: _storedInfo['id']!,
            firstName: _storedInfo['firstName']!,
            lastName: _storedInfo['lastName']!,
            password: _storedInfo['password']!,
            phoneNumber: _storedInfo['phoneNumber']!);

        // check data from database if exist
        return [false];
      } else {
        // login

        return [true];
      }
    } catch (e) {
      storage.deleteAll();
    }
    return true;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Chat"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              bool isLogin = snapshot.data[0];

              if (isLogin) {
                return Center(
                  child: Flex(
                    direction: Axis.vertical,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            margin: EdgeInsets.only(top: 50.0),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: 50.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                      Flexible(
                        flex: 2,
                        child: CustomWidget.textField(
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          labelText: "Phone number",
                          hintText: "09xxxxxxxxx",
                          width: 250,
                          height: 100,
                          errorText: _phoneNumberErr,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: CustomWidget.textField(
                            controller: _passswordController,
                            keyboardType: TextInputType.visiblePassword,
                            isPassword: true,
                            labelText: "Password",
                            hintText: "",
                            width: 250,
                            height: 100,
                            errorText: _passwordErr,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.loose,
                        child: Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: CustomWidget.textButton(
                              onPressed: () {
                                setState(() {
                                  _passwordErr = null;
                                  _phoneNumberErr = null;
                                });
                                Navigator.pushNamed(context, signUpPage);
                              },
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              )),
                        ),
                      ),
                      Flexible(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.only(top: 50.0),
                          child: CustomWidget.outlinedButton(
                            onPressed: () {
                              if (_passswordController.text == "" ||
                                  _phoneNumberController.text == "") {
                                setState(() {
                                  _phoneNumberErr = "Required";
                                  _passwordErr = "Required";
                                });
                              } else {
                                // check if credentials
                                setState(() {
                                  _phoneNumberErr = " ";
                                  _passwordErr =
                                      "Invalid password or phone number.";
                                });
                              }
                            },
                            minWidth: 250,
                            child: Icon(
                              Icons.arrow_right_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                ),
              );
            }
            return Center(
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: Utility.loadingCircular(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print("Deactive sign up.");
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("Dispose sign up.");

    try {
      _passswordController.dispose();
      _passswordController.dispose();
    } catch (e) {
      print(e.toString());
    }

    super.dispose();
  }
}

class AccountInfo {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String password;
  final String id;

  AccountInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.phoneNumber,
  });
}
