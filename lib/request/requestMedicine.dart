import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:research_mobile_app/objects/medicine.dart';
import 'package:research_mobile_app/request/httpRequest.dart';

class RequestMedicine extends MyHttpRequest {
  final String _getAll = "api/get/medicine/all";

  Future<List<Medicine>> QueryAll() async {
    final response = await getRequest(requestPath: _getAll);
    if (response.statusCode == 201) {
      List<Medicine> _allMedicine = [];
      var data = jsonDecode(response.body);
      data.forEach((element) {
        Medicine medicine = Medicine.fromJson(element);
        _allMedicine.add(medicine);
      });

      return _allMedicine;
    } else {
      throw Exception(
          "Failed to get response \nError Code: ${response.statusCode}");
    }
  }
}
