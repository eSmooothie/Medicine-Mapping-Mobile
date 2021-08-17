import 'package:flutter/material.dart';

import 'package:research_mobile_app/helper/page_transition.dart';
import 'package:research_mobile_app/pages/chatSignIn.dart';
import 'package:research_mobile_app/pages/landing.dart';
import 'package:research_mobile_app/pages/search.dart';
import 'package:research_mobile_app/pages/medicineInfo.dart';
import 'package:research_mobile_app/pages/pharmacyInfo.dart';

// Routes of the app
const String landingPage = "/";
const String searchPage = "/search";
const String medicineInfoPage = "/medicineInfo";
const String pharmacyInfoPage = "/pharmacyInfo";
const String signUpPage = "/signUp";

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
        MedicineInfo(
          title: "Medicine Information",
          arguments: route.arguments,
        ),
      );

    case pharmacyInfoPage:
      return Transition().page(PharmacyInformation(
        title: "Pharmacy Information",
        arguments: route.arguments,
      ));

    case signUpPage:
      return Transition().page(SignIn());
    default:
      return Transition().page(
        LandingPage(title: "Map"),
      );
  }
}
