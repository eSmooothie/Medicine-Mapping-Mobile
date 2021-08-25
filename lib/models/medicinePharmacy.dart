import 'package:json_annotation/json_annotation.dart';

import 'pharmacy.dart';

part 'medicinePharmacy.g.dart';

@JsonSerializable()
class MedicinePharmacy {
  final Pharmacy pharmacy;
  final bool isStock;
  final double price;

  MedicinePharmacy(
    this.pharmacy,
    this.isStock,
    this.price,
  );

  factory MedicinePharmacy.fromJson(Map<String, dynamic> json) =>
      _$MedicinePharmacyFromJson(json);

  Map<String, dynamic> toJson() => _$MedicinePharmacyToJson(this);
}
