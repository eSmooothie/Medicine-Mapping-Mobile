// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicinePharmacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicinePharmacy _$MedicinePharmacyFromJson(Map<String, dynamic> json) {
  return MedicinePharmacy(
    Pharmacy.fromJson(json['pharmacy'] as Map<String, dynamic>),
    json['isStock'] as bool,
    (json['price'] as num).toDouble(),
  );
}

Map<String, dynamic> _$MedicinePharmacyToJson(MedicinePharmacy instance) =>
    <String, dynamic>{
      'pharmacy': instance.pharmacy,
      'isStock': instance.isStock,
      'price': instance.price,
    };
