import 'dart:convert';

import 'httpRequest.dart';

class RequestPatient extends MyHttpRequest {
  String addNewUserPath = "api/new/user";
  String getUserInfoPath = "api/get/user";
  Future<Map<String, dynamic>> getUserInfo({required Object? data}) async {
    final response = await postRequest(
      requestPath: getUserInfoPath,
      data: data,
    );
    Map<String, dynamic> result = {
      "reasonPhrase": response.reasonPhrase,
      "statusCode": response.statusCode,
    };
    if (response == null) {
      throw Exception("Failed to establish connection.");
    }
    if (response.statusCode != 205) {
      var decode = jsonDecode(response.body);
      result["nickname"] = decode["NICKNAME"];
      result["phoneNumber"] = decode["CONTACT_NO"];
    }

    return result;
  }

  Future<Map<String, dynamic>> addNewUser({required Object? data}) async {
    final response = await postRequest(
      requestPath: addNewUserPath,
      data: data,
    );
    var decodedJson = jsonDecode(response.body);
    Map<String, dynamic> result = {
      "reasonPhrase": decodedJson['reasonPhrase'],
      "statusCode": decodedJson['statusCode'],
    };
    if (response == null) {
      throw Exception("Failed to establish connection.");
    }
    return result;
  }
}
