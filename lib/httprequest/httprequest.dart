import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:research_mobile_app/objects/medicine.dart';

class MyHttpRequest {
  static const String url = "http://192.168.254.104:9093/";

  Future<List<Medicine>> QueryAllMedicine() async {
    final response = await http.get(
      Uri.parse(url + "api/get/medicine/all"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
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
