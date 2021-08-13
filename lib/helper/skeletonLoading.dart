import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';

class SkeletonContainer extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;

  const SkeletonContainer._({
    this.width = double.infinity,
    this.height = double.infinity,
    this.child,
    Key? key,
  }) : super(key: key);

  const SkeletonContainer.square({
    double width = double.infinity,
    double height = double.infinity,
    Widget? child,
  }) : this._(width: width, height: height, child: child);

  @override
  Widget build(BuildContext context) {
    return SkeletonAnimation(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: child,
      ),
    );
  }
}
