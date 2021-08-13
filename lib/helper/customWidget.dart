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
          contentPadding: EdgeInsets.only(left: padding),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          border: new OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
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
    Color backgroundColor = Colors.blue,
    BorderSide? side,
    OutlinedBorder? shape,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      child: child,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(minWidth, minHeight),
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
}
