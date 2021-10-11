import 'dart:convert';

import 'package:http/http.dart';
import 'package:research_mobile_app/models/notificationModel.dart';

import 'httpRequest.dart';

class RequestNotification extends MyHttpRequest {
  String path = "/api/get/announcement";

  Future<dynamic> getNotifications() async {
    final response = await getRequest(requestPath: path);

    if (response != null && response.statusCode == 200) {
      List<NotificationModel> _notification = [];
      var decode = jsonDecode(response.body);
      decode.forEach((element) {
        NotificationModel _notif = NotificationModel.fromJson(element);
        _notification.add(_notif);
      });

      return _notification;
    } else {
      if (response == null) {
        throw Exception("Failed to establish connection.");
      }
      throw Exception(
          "Failed to get response \nError Code: ${response.statusCode}");
    }
  }
}
