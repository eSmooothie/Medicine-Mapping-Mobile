import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Transition {
  PageTransitionType _pageTransitionType(String name) {
    switch (name) {
      case "fade":
        return PageTransitionType.fade;
      case "left to right":
        return PageTransitionType.leftToRight;
      case "right to left":
        return PageTransitionType.rightToLeft;
      case "top to bottom":
        return PageTransitionType.topToBottom;
      case "bottom to top":
        return PageTransitionType.bottomToTop;
      case "right to left with fade":
        return PageTransitionType.rightToLeftWithFade;
      case "left to right with fade":
        return PageTransitionType.leftToRightWithFade;
      default:
        return PageTransitionType.fade;
    }
  }

  PageTransition page(Widget nextPage,
      {Widget? currentPage,
      String transitionType = "fade",
      int duration = 300}) {
    return PageTransition(
      child: nextPage,
      childCurrent: currentPage,
      type: _pageTransitionType(transitionType),
      duration: Duration(milliseconds: duration),
      settings: RouteSettings(arguments: "test"),
    );
  }
}
