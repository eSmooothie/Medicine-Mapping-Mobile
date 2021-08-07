import 'package:flutter/material.dart';

class Utility {
  static List<Widget> loading = [
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
