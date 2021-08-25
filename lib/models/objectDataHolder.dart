import 'package:research_mobile_app/exportModel.dart';

class ObjectItemDataHolder {
  final String name;
  final String description;
  final Object object;
  ObjectItemDataHolder({
    required this.name,
    required this.description,
    required this.object,
  });
}

class InventoryItemDataHolder {
  final String medicineName;
  final String medicineDescription;
  final String price;
  final bool isStock;
  final Medicine medicineObj;

  InventoryItemDataHolder({
    required this.medicineName,
    required this.medicineDescription,
    required this.price,
    required this.isStock,
    required this.medicineObj,
  });
}

class PharmacyMedicineDataHolder {
  final String pharmacyName;
  final String pharmacyAddress;
  final double price;
  final bool isStock;
  final Pharmacy pharmacyObj;

  PharmacyMedicineDataHolder({
    required this.pharmacyName,
    required this.pharmacyAddress,
    required this.price,
    required this.isStock,
    required this.pharmacyObj,
  });
}
