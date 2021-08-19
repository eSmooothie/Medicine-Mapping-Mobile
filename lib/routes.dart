import 'package:flutter/material.dart';

import 'package:research_mobile_app/helper/page_transition.dart';
import 'package:research_mobile_app/pages/chat.dart';
import 'package:research_mobile_app/pages/chatSignIn.dart';
import 'package:research_mobile_app/pages/chatSignUp.dart';
import 'package:research_mobile_app/pages/displayDirection.dart';
import 'package:research_mobile_app/pages/inbox.dart';
import 'package:research_mobile_app/pages/landing.dart';
import 'package:research_mobile_app/pages/search.dart';
import 'package:research_mobile_app/pages/medicineInfo.dart';
import 'package:research_mobile_app/pages/pharmacyInfo.dart';
import 'package:research_mobile_app/pages/getDirection.dart';
import 'package:research_mobile_app/pages/test.dart';

// Routes of the app
const String landingPage = "/";
const String searchPage = "/search";
const String medicineInfoPage = "/medicineInfo";
const String pharmacyInfoPage = "/pharmacyInfo";
const String signInPage = "/signIn";
const String signUpPage = "/singUp";
const String inboxPage = "/inbox";
const String chatBoxPage = "/chatBox";
const String getDirectionPage = "/getDirection";
const String displayDirectionPage = "/displayDirection";

const String testPage = "/test";

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

    case signInPage:
      return Transition().page(SignIn());
    case signUpPage:
      return Transition().page(SignUp());

    case inboxPage:
      return Transition().page(Inbox());

    case getDirectionPage:
      return Transition().page(GetDirection(
        arguments: route.arguments,
      ));
    case chatBoxPage:
      return Transition().page(ChatBox(
        arguments: route.arguments,
      ));
    case displayDirectionPage:
      return Transition().page(DisplayDirection(
        arguments: route.arguments,
      ));

    case testPage:
      return Transition().page(Test());
    default:
      return Transition().page(
        LandingPage(title: "Map"),
      );
  }
}
