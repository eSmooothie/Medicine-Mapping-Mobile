import 'dart:convert';
import 'package:http/http.dart';
import 'package:research_mobile_app/exportModel.dart';
import 'package:research_mobile_app/request/httpRequest.dart';

class RequestPharmacy extends MyHttpRequest {
  final String _getAll = "api/get/pharmacy/all";
  final String _getInventory = "api/get/pharmacy/inventory";
  // ignore: non_constant_identifier_names
  Future<List<Pharmacy>> QueryAll() async {
    final response = await getRequest(requestPath: _getAll);
    if (response.statusCode == 201) {
      List<Pharmacy> _allPharmacy = [];
      var data = jsonDecode(response.body);
      data.forEach((element) {
        Pharmacy pharmacy = Pharmacy.fromJson(element);
        _allPharmacy.add(pharmacy);
      });

      return _allPharmacy;
    } else {
      throw Exception(
          "Failed to get response \nError Code: ${response.statusCode}");
    }
  }

  Future<List<PharmaInventory>> getMedicine(
      {required String pharmacyId}) async {
    Map<String, dynamic> params = {
      'pharmaId': pharmacyId,
    };
    Response response = await postRequest(
      requestPath: _getInventory,
      data: params,
    );
    List<PharmaInventory> pharmaInventory = [];
    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      decode.forEach((json) {
        PharmaInventory data = PharmaInventory.fromJson(json);
        pharmaInventory.add(data);
      });
    } else {
      throwException(response: response);
    }

    return pharmaInventory;
  }
}
