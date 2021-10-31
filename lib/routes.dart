import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:research_mobile_app/exportModel.dart';

import 'package:research_mobile_app/helper/page_transition.dart';
import 'package:research_mobile_app/pages/chat.dart';
import 'package:research_mobile_app/pages/get_direction.dart';
import 'package:research_mobile_app/pages/google_map.dart';
import 'package:research_mobile_app/pages/inbox.dart';
import 'package:research_mobile_app/pages/landing.dart';
import 'package:research_mobile_app/pages/login.dart';
import 'package:research_mobile_app/pages/notif.dart';

import 'package:research_mobile_app/pages/registration.dart';

// Routes of the app
const String landingPage = "/";
const String mapPage = "/map";
const String directionPage = "/direction";
const String registerPage = "/register";
const String loginPage = "/login";

const String chatBoxPage = "/chatBox";

const String notifPage = "/notif";

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
    case registerPage:
      return Transition().page(Registration());
    case loginPage:
      return Transition().page(Login(
        pharmacy: route.arguments as Pharmacy,
      ));
    case chatBoxPage:
      return Transition().page(
        ChatBox(pharmacy: route.arguments as Pharmacy),
      );
    case notifPage:
      return Transition().page(Notif());
    default:
      return Transition().page(
        LandingPage(),
      );
  }
}
