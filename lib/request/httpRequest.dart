import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

class MyHttpRequest {
  String _url = "https://med-mapping.com/"; // production
  // String _url = "http://192.168.254.103:9093/"; // development

  String get serverUrl {
    return _url;
  }

  @protected
  Future<http.Response> getRequest({required String requestPath}) async {
    try {
      http.Response response = await http.get(
        Uri.parse(_url + requestPath),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      return response;
    } catch (e) {
      throw ErrorDescription("Failed to establish connection.");
    }
  }

  @protected
  Future<http.Response> postRequest({
    required String requestPath,
    required Object? data,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse(_url + requestPath),
        body: data,
      );
      return response;
    } catch (e) {
      throw ErrorDescription("Failed to establish connection.");
    }
  }

  dynamic customRequest({
    required String requestPath,
    required String method,
    required Map<String, dynamic> params,
  }) async {
    Uri destPath = Uri.parse(_url + requestPath);

    if (method == "GET") {
      final Uri newUri = destPath.replace(queryParameters: params);
      var request = await http.get(newUri, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      return request;
    } else {
      // Post
    }
  }

  void throwException({
    required http.Response response,
  }) {
    throw ErrorHint("${response.statusCode}: ${response.reasonPhrase}");
  }
}
