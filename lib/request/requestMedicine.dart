import 'dart:convert';

import 'package:http/http.dart';
import 'package:research_mobile_app/exportModel.dart';
import 'package:research_mobile_app/request/httpRequest.dart';

class RequestMedicine extends MyHttpRequest {
  final String _getAll = "api/get/medicine/all";
  final String _getGeneralClassification = "api/get/GeneralClassifications";
  final String _getMedicineForm = "api/get/MedicineForms";
  final String _filterMedicine = "/api/get/medicine/filter";

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

  Future<List<Medicine>> filterMedicine({
    required Map<String, List<String>> filter,
  }) async {
    // format query string
    // so that PHP can read it as an array
    Map<String, List<String>> params = {};
    filter.forEach((key, value) {
      String newKey = key + "[]";
      params[newKey] = value;
    });
    Response response = await customRequest(
      requestPath: _filterMedicine,
      method: "GET",
      params: params,
    );
    List<Medicine> result = [];
    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      decode.forEach((json) {
        Medicine med = Medicine.fromJson(json);
        result.add(med);
      });
    } else {
      throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
    }

    return result;
  }

  Future<List<GeneralClassification>> getGeneralClassification() async {
    List<GeneralClassification> listData = [];
    Response response =
        await getRequest(requestPath: _getGeneralClassification);

    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      decode.forEach((json) {
        GeneralClassification data = GeneralClassification.fromJson(json);
        listData.add(data);
      });
    } else {
      throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
    }
    return listData;
  }

  Future<List<MedicineForm>> getMedicineForm() async {
    List<MedicineForm> listData = [];
    Response response = await getRequest(requestPath: _getMedicineForm);
    if (response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      decode.forEach((json) {
        MedicineForm data = MedicineForm.fromJson(json);
        listData.add(data);
      });
    } else {
      throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
    }
    return listData;
  }
}
