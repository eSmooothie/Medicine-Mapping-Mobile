import 'package:flutter/material.dart';
import 'package:research_mobile_app/exports.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? _phoneNumberErr;
  String? _passwordErr;
  String? _firstNameErr;
  String? _lastNameErr;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passswordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                  keyboardType: TextInputType.phone,
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
                  keyboardType: TextInputType.phone,
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
                flex: 5,
                child: Container(
                  margin: EdgeInsets.only(top: 50.0),
                  child: CustomWidget.outlinedButton(
                    onPressed: () {
                      setState(() {
                        _passwordErr = (_passswordController.text == "")
                            ? "Required"
                            : null;
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
                          _phoneNumberErr == null &&
                          _passwordErr == null) {
                        // Save data to db.
                        // Save data to storage.
                        // Proceed to inbox
                        print("x");
                        Navigator.popAndPushNamed(context, inboxPage);
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
    // TODO: implement deactivate
    print("Deactivate sign up page.");
    super.deactivate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("Dispose sign up page.");
    super.dispose();
  }
}
