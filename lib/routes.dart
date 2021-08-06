import 'package:flutter/material.dart';

import 'helper/page_transition.dart';
import 'pages/landing.dart';
import 'pages/search.dart';

// Routes of the app
const String landingPage = "/";
const String searchPage = "/search";

// set route
Route<dynamic> appRoutes(RouteSettings route) {
  switch (route.name) {
    case landingPage:
      return Transition().page(LandingPage(
        title: "Map",
      ));
    case searchPage:
      return Transition().page(Search(
        title: "Search",
      ));
    default:
      return Transition().page(LandingPage(title: "Map"));
  }
}
