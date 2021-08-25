import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/request/requestPatient.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? _phoneNumberErr;
  var pharmacyInfo;
  TextEditingController _phoneNumberController = TextEditingController();

  Future _future = Future<bool>(() async {
    final storage = new FlutterSecureStorage();
    final AccountInfo _accountInfo;
    final Map<String, String> _storedInfo;
    // check if credential is stored in the local storage.

    try {
      _storedInfo = await storage.readAll();
      if (_storedInfo.containsKey("firstName") &&
          _storedInfo.containsKey("lastName") &&
          _storedInfo.containsKey("phoneNumber")) {
        _accountInfo = new AccountInfo(
            firstName: _storedInfo['firstName']!,
            lastName: _storedInfo['lastName']!,
            phoneNumber: _storedInfo['phoneNumber']!);

        // check if exist in db
        Map<String, dynamic> data = {
          "phoneNumber": _accountInfo.phoneNumber,
        };
        Map<String, dynamic> result =
            await RequestPatient().getUserInfo(data: data);

        if (result.containsKey("phoneNumber")) {
          return true;
        }
        return false;
      } else {
        // need to enter credentials
        return false;
      }
    } catch (e) {
      storage.deleteAll();
    }
    return false;
  });

  @override
  void initState() {
    super.initState();
    setState(() {
      pharmacyInfo = widget.arguments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              bool hasCredentials = snapshot.data;

              if (hasCredentials) {
                SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                  Navigator.popAndPushNamed(
                    context,
                    chatBoxPage,
                    arguments: pharmacyInfo,
                  );
                });
              } else {
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
                        fit: FlexFit.loose,
                        child: Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: CustomWidget.textButton(
                              onPressed: () {
                                setState(() {
                                  _phoneNumberErr = null;
                                });
                                Navigator.pushNamed(
                                  context,
                                  signUpPage,
                                  arguments: pharmacyInfo,
                                );
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
                            onPressed: () async {
                              if (_phoneNumberController.text == "") {
                                setState(() {
                                  _phoneNumberErr = "Required";
                                });
                              } else {
                                // check if legit phone number
                                bool phoneNumberIsValid = true;

                                // Pattern pattern = r'^(?:[+0]9)?[0-9]{10}$';
                                RegExp regExp =
                                    new RegExp(r"^(?:[+0]9)?[0-9]{9}$");
                                if (!regExp
                                    .hasMatch(_phoneNumberController.text)) {
                                  phoneNumberIsValid = false;
                                }
                                // check phone number if exist
                                Map<String, dynamic> data = {
                                  'phoneNumber': _phoneNumberController.text,
                                };
                                Map<String, dynamic> request =
                                    await RequestPatient().getUserInfo(
                                  data: data,
                                );
                                // print(request);
                                if (!request.containsKey("phoneNumber") ||
                                    !phoneNumberIsValid) {
                                  setState(() {
                                    _phoneNumberErr = "Invalid phone number";
                                    _phoneNumberController.clear();
                                  });
                                } else {
                                  final storage = new FlutterSecureStorage();
                                  try {
                                    storage.write(
                                      key: "firstName",
                                      value: request["firstName"],
                                    );
                                    storage.write(
                                      key: "lastName",
                                      value: request["lastName"],
                                    );
                                    storage.write(
                                      key: "phoneNumber",
                                      value: request["phoneNumber"],
                                    );
                                  } catch (e) {
                                    storage.deleteAll();
                                  }
                                  // Navigator.popAndPushNamed(context, inboxPage);
                                  Navigator.popAndPushNamed(
                                    context,
                                    chatBoxPage,
                                    arguments: pharmacyInfo,
                                  );
                                }
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: CustomWidget.errorContainer(
                      errorMessage: snapshot.error.toString()),
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
    print("Deactive sign up.");
    super.deactivate();
  }

  @override
  void dispose() {
    print("Dispose sign up.");

    _phoneNumberController.dispose();
    super.dispose();
  }
}

class AccountInfo {
  final String phoneNumber;
  final String firstName;
  final String lastName;

  AccountInfo({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });
}
