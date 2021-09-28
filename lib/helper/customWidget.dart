import 'package:flutter/material.dart';

class CustomWidget {
  static Widget textField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String hintText = "Hint text",
    String? errorText,
    String labelText = "",
    double radius = 10.0,
    double height = 50,
    double width = 200,
    double padding = 20.0,
    bool isPassword = false,
    Color borderColor = Colors.blueAccent,
    Widget? prefixIcon,
    Function(String)? onSubmit,
    Function(String)? onChanged,
    Function()? onEditingComplete,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        onSubmitted: onSubmit,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          contentPadding: EdgeInsets.only(left: padding),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
          border: new OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        style: TextStyle(
          color: Colors.blue.shade700,
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      ),
    );
  }

  static Widget outlinedButton({
    required Function()? onPressed,
    required Widget child,
    double minWidth = 150,
    double minHeight = 50,
    Size? fixedSize,
    Color backgroundColor = Colors.blue,
    BorderSide? side,
    OutlinedBorder? shape,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: child,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(minWidth, minHeight),
        fixedSize: fixedSize,
        backgroundColor: backgroundColor,
        side: side,
        shape: shape,
      ),
    );
  }

  static Widget elevatedButton({
    required Function()? onPressed,
    required Widget child,
    double minWidth = 150,
    double minHeight = 50,
    double? elevation,
    Color backgroundColor = Colors.blue,
    BorderSide? side,
    OutlinedBorder? shape,
    EdgeInsets? padding,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(minWidth, minHeight),
        elevation: elevation,
        padding: padding,
        side: side,
        shape: shape,
      ),
    );
  }

  static Widget textButton({
    required Function()? onPressed,
    required Widget child,
    double minWidth = 150,
    double minHeight = 50,
    double? elevation,
    Color backgroundColor = Colors.blue,
    BorderSide? side,
    OutlinedBorder? shape,
    EdgeInsets? padding,
  }) {
    return TextButton(
      onPressed: onPressed,
      child: child,
      style: TextButton.styleFrom(
        minimumSize: Size(minWidth, minHeight),
        elevation: elevation,
        padding: padding,
        side: side,
        shape: shape,
      ),
    );
  }

  static List<Widget> errorContainer({
    required String errorMessage,
    IconData errorIcon = Icons.error_outline,
  }) {
    return <Widget>[
      Icon(
        errorIcon,
        color: Colors.red,
        size: 60,
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            '$errorMessage',
            textAlign: TextAlign.center,
          ),
        ),
      )
    ];
  }

  static void mySnackBar({
    required BuildContext context,
    required String message,
    DismissDirection dismissDirection = DismissDirection.up,
    double position = 200,
    Color backgroundColor: Colors.blueAccent,
    int duration = 4,
  }) {
    double screenHeight = MediaQuery.of(context).size.height;
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(20, 0, 20, screenHeight - position),
      dismissDirection: dismissDirection,
      backgroundColor: backgroundColor,
      duration: Duration(seconds: duration),
      content: Container(
        child: Text(
          message,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
