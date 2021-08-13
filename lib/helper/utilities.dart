import 'package:flutter/material.dart';

class Utility {
  static List<Widget> loadingCircular = [
    SizedBox(
      child: CircularProgressIndicator(),
      width: 50,
      height: 50,
    ),
    Padding(
      padding: EdgeInsets.only(top: 16),
      child: Text("Loading..."),
    ),
  ];

  Widget medicineContainer({
    required String brandName,
    required String genericName,
    required String dosage,
    required String dosageForm,
    required Function()? onTap,
  }) {
    return SizedBox(
      height: 70,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(50.0),
          splashColor: Colors.blue,
          focusColor: Colors.blue.shade100,
          highlightColor: null,
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: Text("Logo"),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              )
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Future errorDialog({
    required BuildContext context,
    String errtitle = "Error",
    String errContent = "Error Message.",
  }) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => _alertDialog(
              context: context,
              title: errtitle,
              content: errContent,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ));
  }

  Widget _alertDialog({
    required BuildContext context,
    String title = "Title",
    String content = "Content",
    List<Widget>? actions,
  }) {
    return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content),
          ],
        ),
        actions: actions);
  }
}
