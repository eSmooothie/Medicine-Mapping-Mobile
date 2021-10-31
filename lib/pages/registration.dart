import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:research_mobile_app/exportHelper.dart';
import 'package:research_mobile_app/request/requestPatient.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late TextEditingController _nickNameController;
  late TextEditingController _phonenumberController;
  late FlutterSecureStorage storage;
  String? _phoneNumberErr;
  String? _nicknameErr;
  @override
  void initState() {
    // TODO: implement initState
    _nickNameController = TextEditingController();
    _phonenumberController = TextEditingController();
    storage = FlutterSecureStorage();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nickNameController.dispose();
    _phonenumberController.dispose();
    super.dispose();
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
      body: SafeArea(
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
                  "Register",
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 5.0),
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "How will we address you?",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        CustomWidget.textField(
                          prefixIcon: Icon(Icons.person),
                          controller: _nickNameController,
                          width: MediaQuery.of(context).size.width - 90,
                          borderColor: HexColor("#A6DCEF"),
                          hintText: "Nickname",
                          labelText: "Nickname",
                          errorText: _nicknameErr,
                          textStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 5.0),
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Text(
                            "Phone number",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        CustomWidget.textField(
                          prefixIcon: Icon(Icons.phone_android),
                          controller: _phonenumberController,
                          keyboardType: TextInputType.number,
                          width: MediaQuery.of(context).size.width - 90,
                          borderColor: HexColor("#A6DCEF"),
                          hintText: "Phone number",
                          labelText: "Phone number",
                          errorText: _phoneNumberErr,
                          textStyle: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () async {
                        print("Nickname: ${_nickNameController.text}");
                        print("Phone: ${_phonenumberController.text}");

                        // TODO: validate

                        // display error message when textfield is empty
                        setState(() {
                          _phoneNumberErr = (_phonenumberController.text == "")
                              ? "Required"
                              : null;
                          _nicknameErr = (_nickNameController.text == "")
                              ? "Required"
                              : null;
                        });

                        // check if number is valid
                        if (_phonenumberController.text != "") {
                          RegExp regExp = new RegExp(r"^(?:[+0]9)?[0-9]{9}$");
                          if (!regExp.hasMatch(_phonenumberController.text)) {
                            setState(() {
                              _phoneNumberErr = "Invalid phone number format.";
                            });
                          }
                        } else {
                          if (_phonenumberController.text != "" &&
                              _nickNameController.text != "") {
                            Map<String, String> newUserInfo = {
                              'nickname': _nickNameController.text,
                              'phoneNumber': _phonenumberController.text,
                            };

                            Map<String, dynamic> response =
                                await RequestPatient().addNewUser(
                              data: newUserInfo,
                            );

                            print(response);
                            // check if phonenumber already exist
                            if (response['statusCode'] == "400" &&
                                _phonenumberController.text != "") {
                              setState(() {
                                _phoneNumberErr = response['reasonPhrase'];
                                _phonenumberController.clear();
                              });
                            } else if (_phoneNumberErr == null) {
                              // store the data

                              storage.write(
                                key: "user_nickname",
                                value: _nickNameController.text,
                              );
                              storage.write(
                                key: "user_phoneNumber",
                                value: _phonenumberController.text,
                              );

                              // wait for the modal to close
                              await Utility().showModal(
                                context: context,
                                title: "Message",
                                content: "Successfully registered.",
                              );

                              // back to login
                              Navigator.pop(context);
                            }
                          }
                        }
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: HexColor("#A6DCEF"),
                        fixedSize: Size(200, 50),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
