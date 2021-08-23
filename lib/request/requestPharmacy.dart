import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:research_mobile_app/exports.dart';
import 'package:research_mobile_app/request/httpRequest.dart';

class RequestPharmacy extends MyHttpRequest {
  final String _getAll = "api/get/pharmacy/all";

  Future<List<Pharmacy>> QueryAll() async {
    final response = await getRequest(requestPath: _getAll);
    if (response.statusCode == 201) {
      List<Pharmacy> _allPharmacy = [];
      var data = jsonDecode(response.body);
      data.forEach((element) {
        // Pharmacy pharmacy = Pharmacy.fromJson(element);
        // _allPharmacy.add(pharmacy);
      });

      return _allPharmacy;
    } else {
      throw Exception(
          "Failed to get response \nError Code: ${response.statusCode}");
    }
  }
}
