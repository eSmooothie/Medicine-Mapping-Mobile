import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:research_mobile_app/request/httpRequest.dart';

class MapRequest extends MyHttpRequest {
  final String _apiKey = "AIzaSyDzgtPJeqX3e4XCPTelTsenA-gPz3LzxaY";

  Future<String> getAddress({required LatLng position}) async {
    String _apiUri =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$_apiKey";
    Uri url = Uri.parse(_apiUri);
    final response = await http.get(url);

    // ignore: unnecessary_null_comparison
    if (response != null && response.statusCode == 200) {
      var rawData = jsonDecode(response.body);
      var result = rawData["results"][0];
      String formattedAddress = result["formatted_address"];
      return formattedAddress;
    } else {
      // ignore: unnecessary_null_comparison
      if (response == null) {
        throw Exception("Failed to establish connection.");
      }
      throwException(response: response);
    }
    return "";
  }

  Future<Map<String, dynamic>> getRoute({
    required LatLng origin,
    required LatLng destination,
    bool alternative = true,
    String mode = "walking",
    String avoid = "",
    String travelModel = "best_guess",
  }) async {
    String _apiUri =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&avoid=$avoid&mode=$mode&alternatives=$alternative&key=$_apiKey";
    Uri url = Uri.parse(_apiUri);
    final response = await http.get(url);
    Map<String, dynamic> allPossibleRoute = {};
    // ignore: unnecessary_null_comparison
    if (response != null && response.statusCode == 200) {
      var rawData = jsonDecode(response.body);
      var routes = rawData["routes"];

      routes.forEach((dynamic routeData) {
        // print(routeData);
        Map<String, dynamic> data = {
          'bounds': routeData["bounds"],
          'distance': routeData["legs"][0]["distance"],
          'duration': routeData["legs"][0]["duration"],
          'steps': routeData["legs"][0]["steps"],
          'warnings': routeData["warnings"],
          'overview_polyline': routeData["overview_polyline"],
        };
        allPossibleRoute["start_address"] =
            routeData["legs"][0]["start_address"];
        allPossibleRoute[routeData["summary"]] = data;
      });

      return allPossibleRoute;
    } else {
      // ignore: unnecessary_null_comparison
      if (response == null) {
        throw Exception("Failed to establish connection.");
      }
      throwException(response: response);
    }
    return allPossibleRoute;
  }
}
