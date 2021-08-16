import 'package:flutter/material.dart';

import 'helper/page_transition.dart';
import 'pages/landing.dart';
import 'pages/search.dart';
import 'pages/medicineInfo.dart';

// Routes of the app
const String landingPage = "/";
const String searchPage = "/search";
const String medicineInfoPage = "/medicineInfo";
const String pharmacyInfoPage = "/pharmacyInfo";

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
        arguments: route.arguments,
      ));

    case medicineInfoPage:
      return Transition().page(
        MedicineInfo(title: "Medicine Information", arguments: route.arguments),
      );
    default:
      return Transition().page(LandingPage(title: "Map"));
  }
}
