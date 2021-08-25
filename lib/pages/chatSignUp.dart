import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/request/requestPatient.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var pharmacyInfo;
  String? _phoneNumberErr;
  String? _firstNameErr;
  String? _lastNameErr;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    setState(() {
      pharmacyInfo = widget.arguments;
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Chat"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
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
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 50.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Flexible(
                flex: 2,
                child: CustomWidget.textField(
                  controller: _firstNameController,
                  keyboardType: TextInputType.text,
                  labelText: "First Name",
                  hintText: "",
                  width: 250,
                  height: 100,
                  errorText: _firstNameErr,
                ),
              ),
              Flexible(
                flex: 2,
                child: CustomWidget.textField(
                  controller: _lastNameController,
                  keyboardType: TextInputType.text,
                  labelText: "Last Name",
                  hintText: "",
                  width: 250,
                  height: 100,
                  errorText: _lastNameErr,
                ),
              ),
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
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child: CustomWidget.outlinedButton(
                    onPressed: () async {
                      setState(() {
                        _phoneNumberErr = (_phoneNumberController.text == "")
                            ? "Required"
                            : null;
                        _firstNameErr = (_firstNameController.text == "")
                            ? "Required"
                            : null;
                        _lastNameErr = (_lastNameController.text == "")
                            ? "Required"
                            : null;
                      });

                      if (_lastNameErr == null &&
                          _firstNameErr == null &&
                          _phoneNumberErr == null) {
                        // check if legit phone number
                        bool phoneNumberIsValid = true;

                        // Pattern pattern = r'^(?:[+0]9)?[0-9]{10}$';
                        RegExp regExp = new RegExp(r"^(?:[+0]9)?[0-9]{9}$");
                        if (!regExp.hasMatch(_phoneNumberController.text)) {
                          phoneNumberIsValid = false;
                        }

                        if (!phoneNumberIsValid) {
                          setState(() {
                            _phoneNumberErr = "Invalid phone number";
                            _phoneNumberController.clear();
                          });
                        } else {
                          // Save data to db.
                          Map<String, String> newUserInfo = {
                            'firstName': _firstNameController.text,
                            'lastName': _lastNameController.text,
                            'phoneNumber': _phoneNumberController.text,
                          };
                          var response = await RequestPatient().addNewUser(
                            data: newUserInfo,
                          );
                          print(response);
                          if (response['statusCode'] == "400") {
                            Utility().errorDialog(
                              context: context,
                              errtitle: "Code: ${response['statusCode']}",
                              errContent: "${response['reasonPhrase']}",
                            );

                            setState(() {
                              _phoneNumberController.clear();
                            });
                          } else {
                            // Save data to storage.

                            final storage = new FlutterSecureStorage();
                            try {
                              storage.write(
                                key: "firstName",
                                value: newUserInfo["firstName"],
                              );
                              storage.write(
                                key: "lastName",
                                value: newUserInfo["lastName"],
                              );
                              storage.write(
                                key: "phoneNumber",
                                value: newUserInfo["phoneNumber"],
                              );
                            } catch (e) {
                              storage.deleteAll();
                            }

                            // Back to sign in.

                            Navigator.popAndPushNamed(
                              context,
                              signInPage,
                              arguments: pharmacyInfo,
                            );
                          }
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
        ),
      ),
    );
  }

  @override
  void deactivate() {
    print("Deactivate sign up page.");
    super.deactivate();
  }

  @override
  void dispose() {
    print("Dispose sign up page.");
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
