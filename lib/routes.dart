import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:research_mobile_app/exportModel.dart';

import 'package:research_mobile_app/helper/page_transition.dart';
import 'package:research_mobile_app/pages/chat.dart';
import 'package:research_mobile_app/pages/chatSignIn.dart';
import 'package:research_mobile_app/pages/chatSignUp.dart';
import 'package:research_mobile_app/pages/displayDirection.dart';
import 'package:research_mobile_app/pages/get_direction.dart';
import 'package:research_mobile_app/pages/google_map.dart';
import 'package:research_mobile_app/pages/inbox.dart';
import 'package:research_mobile_app/pages/inquire.dart';
import 'package:research_mobile_app/pages/landing.dart';
import 'package:research_mobile_app/pages/notif.dart';
import 'package:research_mobile_app/pages/search.dart';
import 'package:research_mobile_app/pages/medicineInfo.dart';
import 'package:research_mobile_app/pages/pharmacyInfo.dart';
import 'package:research_mobile_app/pages/getDirection.dart';
import 'package:research_mobile_app/pages/test.dart';
import 'package:research_mobile_app/pages/userProfile.dart';

// Routes of the app
const String landingPage = "/";
const String mapPage = "/map";
const String directionPage = "/direction";
const String inquirePage = "/inquire";

const String searchPage = "/search";
const String medicineInfoPage = "/medicineInfo";
const String pharmacyInfoPage = "/pharmacyInfo";
const String signInPage = "/signIn";
const String signUpPage = "/singUp";
const String inboxPage = "/inbox";
const String chatBoxPage = "/chatBox";
const String getDirectionPage = "/getDirection";
const String displayDirectionPage = "/displayDirection";
const String notifPage = "/notif";
const String userProfilePage = "/userProfile";
const String testPage = "/test";

// set route
Route<dynamic> appRoutes(RouteSettings route) {
  switch (route.name) {
    case landingPage:
      return Transition().page(LandingPage());
    case mapPage:
      return Transition().page(MyMap(
        medicine: route.arguments as Medicine?,
      ));
    case directionPage:
      return Transition().page(
        GetDirection(
          pharmacyLocation: route.arguments as LatLng,
        ),
      );
    case inquirePage:
      return Transition().page(Inquire());
    default:
      return Transition().page(
        LandingPage(),
      );
  }
}
