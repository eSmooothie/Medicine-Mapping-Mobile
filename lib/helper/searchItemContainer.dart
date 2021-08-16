import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:research_mobile_app/exports.dart';

Widget ItemContainer({
  required String title,
  required String description,
  required void Function()? onPressed,
}) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      fixedSize: Size(200, 100),
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
  );
}

Widget ItemContainerSkeleton({
  double titleWidth = 200,
  double descHeight = 20,
}) {
  return Container(
    height: 100,
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
