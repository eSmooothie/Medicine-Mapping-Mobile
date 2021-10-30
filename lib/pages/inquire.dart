import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:research_mobile_app/exportHelper.dart';

class Inquire extends StatefulWidget {
  const Inquire({Key? key}) : super(key: key);

  @override
  _InquireState createState() => _InquireState();
}

class _InquireState extends State<Inquire> {
  late TextEditingController _nickNameController;
  late TextEditingController _phonenumberController;
  @override
  void initState() {
    // TODO: implement initState
    _nickNameController = TextEditingController();
    _phonenumberController = TextEditingController();
    super.initState();
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
                          controller: _nickNameController,
                          width: MediaQuery.of(context).size.width - 90,
                          borderColor: HexColor("#A6DCEF"),
                          hintText: "Nickname",
                          labelText: "Nickname",
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
                          controller: _phonenumberController,
                          width: MediaQuery.of(context).size.width - 90,
                          borderColor: HexColor("#A6DCEF"),
                          hintText: "Phone number",
                          labelText: "Phone number",
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: OutlinedButton(
                      onPressed: () {
                        print("Nickname: ${_nickNameController.text}");
                        print("Phone: ${_phonenumberController.text}");

                        // TODO: validate
                      },
                      child: Text(
                        "Submit",
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
