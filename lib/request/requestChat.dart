import 'dart:convert';

import 'package:http/http.dart';
import 'package:research_mobile_app/exports.dart';

class RequestChat extends MyHttpRequest {
  final String _convoPath = "api/get/chat";
  final String _sendMessagePath = "api/send/message";
  Future<Map<String, String>> getConversation({required Object? data}) async {
    Map<String, String> result = {};

    Response response = await postRequest(
      requestPath: _convoPath,
      data: data,
    );

    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      // print(decode);
      if (decode["status"] == "OK") {
        result["chatId"] = decode["chatId"].toString();
        result["convo"] = decode["convo"];
      }
    }

    return result;
  }

  Future<Response> sendMessage({required Object? data}) async {
    final Response response = await postRequest(
      requestPath: _sendMessagePath,
      data: data,
    );

    return response;
  }
}
