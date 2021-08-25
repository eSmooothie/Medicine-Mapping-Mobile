import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:research_mobile_app/exportHelper.dart';

// ignore: non_constant_identifier_names
Widget ItemContainer({
  required String title,
  required String description,
  required void Function()? onPressed,
}) {
  return IntrinsicHeight(
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.blue.shade100,
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue.shade100),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    "$title",
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Text(
                    "$description",
                    style: TextStyle(
                      color: Colors.blue.shade800,
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

// ignore: non_constant_identifier_names
Widget ItemContainerSkeleton({
  double titleWidth = 200,
  double descHeight = 20,
  double containerHeight = 100,
}) {
  return Container(
    height: containerHeight,
    padding: EdgeInsets.all(18.0),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 2,
          child: SkeletonContainer.square(width: titleWidth, height: 50),
        ),
        Expanded(
          child: Container(),
        ),
        Expanded(
          flex: 5,
          child: SkeletonContainer.square(height: descHeight),
        ),
      ],
    ),
  );
}

// ignore: non_constant_identifier_names
Widget InboxItemContainerSkeleton({
  double titleWidth = 200,
  double descHeight = 20,
}) {
  return Container(
    height: 100,
    padding: EdgeInsets.all(10.0),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.circular(0),
    ),
    child: Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 1,
          child: SkeletonContainer.square(
            height: 50,
            width: 50,
          ),
        ),
        Expanded(
          flex: 5,
          child: SkeletonContainer.square(height: descHeight),
        ),
      ],
    ),
  );
}

// ignore: non_constant_identifier_names
Widget InboxItemContainer({
  required dynamic Function() onPressed,
  required String pharmacyName,
  Widget? notif,
}) {
  return CustomWidget.outlinedButton(
    onPressed: onPressed,
    child: Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Icon(
            Icons.account_circle,
            size: 50.0,
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            "$pharmacyName",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: (notif == null) ? Text("") : notif,
        ),
      ],
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    backgroundColor: Colors.blue.shade100,
    fixedSize: Size.fromHeight(100),
  );
}

// ignore: non_constant_identifier_names
Widget InboxNotifaction({
  required int newMessage,
}) {
  return Ink(
    decoration: BoxDecoration(
      color: Colors.red,
      shape: BoxShape.circle,
    ),
    width: 40,
    height: 40,
    child: InkWell(
      child: Center(
        child: Text(
          "$newMessage",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}

// ignore: non_constant_identifier_names
Widget InventoryItemContainer({
  required String medicineName,
  required String medicineDescription,
  required String price,
  required bool isStock,
  required void Function()? onPressed,
}) {
  return IntrinsicHeight(
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: (isStock) ? Colors.blue.shade100 : Colors.blue.shade50,
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue.shade100),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
      onPressed: (isStock)
          ? onPressed
          : () {
              print("Out of stock.");
            },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "$medicineName",
                          style: TextStyle(
                            color: (isStock)
                                ? Colors.blue.shade800
                                : Colors.blue.shade300,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          "$medicineDescription",
                          style: TextStyle(
                            color: (isStock)
                                ? Colors.blue.shade800
                                : Colors.blue.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (isStock) ? "P$price" : "Out of\nStock",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: (isStock)
                              ? Colors.blue.shade800
                              : Colors.blue.shade300,
                        ),
                      ),
                      Text(
                        (isStock) ? "Price" : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            color: (isStock)
                                ? Colors.blue.shade800
                                : Colors.blue.shade300),
                      ),
                    ],
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

// ignore: non_constant_identifier_names
Widget PharmaMedicineItemContainer({
  required String pharmacyName,
  required String pharmacyAddress,
  required double price,
  required bool isStock,
  required void Function()? onPressed,
}) {
  return IntrinsicHeight(
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: (isStock) ? Colors.blue.shade100 : Colors.blue.shade50,
        textStyle: TextStyle(color: Colors.white),
        padding: EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue.shade100),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
      ),
      onPressed: (isStock)
          ? onPressed
          : () {
              print("Out of Stock");
            },
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          "$pharmacyName",
                          style: TextStyle(
                            color: (isStock)
                                ? Colors.blue.shade800
                                : Colors.blue.shade300,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: Text(
                          "$pharmacyAddress",
                          style: TextStyle(
                            color: (isStock)
                                ? Colors.blue.shade800
                                : Colors.blue.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (isStock) ? "P$price" : "Out of\nStock",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: (isStock)
                              ? Colors.blue.shade800
                              : Colors.blue.shade300,
                        ),
                      ),
                      Text(
                        (isStock) ? "Price" : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
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
