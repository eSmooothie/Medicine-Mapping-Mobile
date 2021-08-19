import 'dart:convert';

import 'package:http/http.dart';
import 'package:research_mobile_app/exports.dart';

class RequestPatient extends MyHttpRequest {
  String addNewUserPath = "api/new/user";
  String getUserInfoPath = "api/get/user";
  Future<Map<String, dynamic>> getUserInfo({required Object? data}) async {
    Response response = await postRequest(
      requestPath: getUserInfoPath,
      data: data,
    );
    Map<String, dynamic> result = {
      "reasonPhrase": response.reasonPhrase,
      "statusCode": response.statusCode,
    };
    if (response.body.isNotEmpty) {
      var decode = jsonDecode(response.body);
      result["firstName"] = decode["FIRST_NAME"];
      result["lastName"] = decode["LAST_NAME"];
      result["phoneNumber"] = decode["CONTACT_NO"];
    }

    return result;
  }

  Future<Map<String, dynamic>> addNewUser({required Object? data}) async {
    Response response = await postRequest(
      requestPath: addNewUserPath,
      data: data,
    );
    var decodedJson = jsonDecode(response.body);
    Map<String, dynamic> result = {
      "reasonPhrase": decodedJson['reasonPhrase'],
      "statusCode": decodedJson['statusCode'],
    };

    return result;
  }
}
