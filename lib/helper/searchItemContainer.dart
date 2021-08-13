import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:research_mobile_app/exports.dart';

Widget SearchItemContainer({
  required String title,
  required String description,
}) {
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      fixedSize: Size(200, 100),
      backgroundColor: Colors.blue,
      textStyle: TextStyle(color: Colors.white),
      padding: EdgeInsets.all(18.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
    ),
    onPressed: () {
      print("clicked...");
    },
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
                    color: Colors.white,
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
                    color: Colors.white,
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

Widget SearchItemContainerSkeleton({
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
  // return OutlinedButton(
  //   style: OutlinedButton.styleFrom(
  //     fixedSize: Size(200, 100),
  //     backgroundColor: Colors.blue,
  //     textStyle: TextStyle(color: Colors.white),
  //     padding: EdgeInsets.all(18.0),
  //     shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.all(Radius.circular(10.0))),
  //   ),
  //   onPressed: () {},
  //   child: Row(
  //     mainAxisSize: MainAxisSize.max,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Expanded(
  //         flex: 5,
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             FittedBox(
  //               fit: BoxFit.fitWidth,
  //               child: SkeletonContainer.square(width: 100, height: 10),
  //             ),
  //             Flexible(
  //               flex: 1,
  //               fit: FlexFit.tight,
  //               child: SkeletonContainer.square(width: 100, height: 100),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   ),
  // );
}
