import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:research_mobile_app/objects/medicine.dart';

class MyHttpRequest {
  String _url = "http://192.168.254.104:9093/";

  String get serverUrl {
    return _url;
  }

  @protected
  dynamic getRequest({required String requestPath}) async {
    return await http.get(
      Uri.parse(_url + requestPath),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

  @protected
  dynamic postRequest({
    required String requestPath,
    required Object? data,
  }) async {
    return await http.post(
      Uri.parse(_url + requestPath),
      body: data,
    );
  }
}
