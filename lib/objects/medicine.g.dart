// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medicine _$MedicineFromJson(Map<String, dynamic> json) {
  return Medicine(
    json['id'] as String,
    json['brandName'] as String,
    json['genericName'] as String,
    json['dosage'] as String,
    json['dosageForm'] as String,
    json['isOTC'] as bool,
    json['description'] as String,
  );
}

Map<String, dynamic> _$MedicineToJson(Medicine instance) => <String, dynamic>{
      'id': instance.id,
      'brandName': instance.brandName,
      'genericName': instance.genericName,
      'dosage': instance.dosage,
      'dosageForm': instance.dosageForm,
      'isOTC': instance.isOTC,
      'description': instance.description,
    };
