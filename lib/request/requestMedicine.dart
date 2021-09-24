import 'dart:convert';

import 'package:http/http.dart';
import 'package:research_mobile_app/exportModel.dart';
import 'package:research_mobile_app/request/httpRequest.dart';

class RequestMedicine extends MyHttpRequest {
  final String _getAll = "api/get/medicine/all";
  final String _getGeneralClassification = "api/get/GeneralClassifications";
  final String _getMedicineForm = "api/get/MedicineForms";
  final String _filterMedicine = "api/get/medicine/filter";
  final String _getAveragePrice = "api/get/medicine/average_price";
  final String _getPharmacies = "api/get/medicine/offer/pharmacies";
  final String _addToTrend = "api/add/tred/medicine";
  // ignore: non_constant_identifier_names
  Future<List<Medicine>> QueryAll() async {
    final response = await getRequest(requestPath: _getAll);
    if (response != null && response.statusCode == 201) {
      List<Medicine> _allMedicine = [];
      var data = jsonDecode(response.body);
      data.forEach((element) {
        Medicine medicine = Medicine.fromJson(element);
        _allMedicine.add(medicine);
      });

      return _allMedicine;
    } else {
      if (response == null) {
        throw Exception("Failed to establish connection.");
      }
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
    final response = await customRequest(
      requestPath: _filterMedicine,
      method: "GET",
      params: params,
    );
    List<Medicine> result = [];
    if (response != null && response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      decode.forEach((json) {
        Medicine med = Medicine.fromJson(json);
        result.add(med);
      });
    } else {
      if (response == null) {
        throw Exception("Failed to establish connection.");
      }
      throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
    }

    return result;
  }

  Future<List<GeneralClassification>> getGeneralClassification() async {
    List<GeneralClassification> listData = [];
    final response = await getRequest(requestPath: _getGeneralClassification);

    if (response != null && response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      decode.forEach((json) {
        GeneralClassification data = GeneralClassification.fromJson(json);
        listData.add(data);
      });
    } else {
      if (response == null) {
        throw Exception("Failed to establish connection.");
      }
      throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
    }
    return listData;
  }

  Future<List<MedicineForm>> getMedicineForm() async {
    List<MedicineForm> listData = [];
    final response = await getRequest(requestPath: _getMedicineForm);
    if (response != null && response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      decode.forEach((json) {
        MedicineForm data = MedicineForm.fromJson(json);
        listData.add(data);
      });
    } else {
      if (response == null) {
        throw Exception("Failed to establish connection.");
      }
      throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
    }
    return listData;
  }

  Future<double> getAveragePrice({required String id}) async {
    double avgPrice = 0;
    Map<String, dynamic> data = {
      "medicineId": id,
    };
    final response = await postRequest(
      requestPath: _getAveragePrice,
      data: data,
    );

    if (response != null && response.statusCode == 200) {
      var decode = jsonDecode(response.body);
      if (decode["AvgPrice"] is int) {
        int price = decode["AvgPrice"];
        avgPrice = price.toDouble();
      } else {
        avgPrice = decode["AvgPrice"].toDouble();
      }
    } else {
      if (response == null) {
        throw Exception("Failed to establish connection.");
      }
      throwException(response: response);
    }

    return avgPrice;
  }

  Future<List<MedicinePharmacy>> getPharmacies({required String id}) async {
    List<MedicinePharmacy> listPharmacies = [];
    Map<String, dynamic> data = {
      "medicineId": id,
    };
    final response = await postRequest(
      requestPath: _getPharmacies,
      data: data,
    );

    if (response != null && response.statusCode == 200) {
      var decode = jsonDecode(response.body);

      decode.forEach((json) {
        MedicinePharmacy data = MedicinePharmacy.fromJson(json);
        listPharmacies.add(data);
      });
    } else {
      if (response == null) {
        throw Exception("Failed to establish connection.");
      }
      throwException(response: response);
    }

    return listPharmacies;
  }

  Future addToTrend({required String id}) async {
    Map<String, dynamic> data = {
      "medicineId": id,
    };

    final response = await postRequest(
      requestPath: _addToTrend,
      data: data,
    );
    if (response == null) {
      throw Exception("Failed to establish connection.");
    }
    if (response.statusCode != 200) {
      throwException(response: response);
    }
  }
}
