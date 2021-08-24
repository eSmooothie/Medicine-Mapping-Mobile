import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import 'httpRequest.dart';

class RequestChat extends MyHttpRequest {
  final String _convoPath = "api/get/chat";
  final String _sendMessagePath = "api/send/message";
  final String _sendImagePath = "api/send/image";
  Future<Map<String, dynamic>> getConversation({required Object? data}) async {
    Map<String, dynamic> result = {};

    http.Response response = await postRequest(
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

  Future<http.Response> sendMessage({required Object? data}) async {
    final http.Response response = await postRequest(
      requestPath: _sendMessagePath,
      data: data,
    );

    return response;
  }

  Future<void> sendImage(
      {required String chatId,
      required String phoneNumber,
      required File tmpFile}) async {
    // open a bytestream
    var stream = new http.ByteStream(tmpFile.openRead());
    // get file length
    var length = await tmpFile.length();

    // string to uri
    var uri = Uri.parse(serverUrl + _sendImagePath);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile(
      'file',
      stream,
      length,
      filename: basename(tmpFile.path),
    );

    // add file to multipart
    request.files.add(multipartFile);

    // add fields
    Map<String, String> data = {
      'chatId': chatId,
      'phoneNumber': phoneNumber,
    };
    request.fields.addAll(data);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
}
