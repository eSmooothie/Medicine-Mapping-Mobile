import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

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
    } else {
      // Post
    }
  }
}
