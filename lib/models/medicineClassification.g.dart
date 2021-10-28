// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicineClassification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineClassification _$MedicineClassificationFromJson(
        Map<String, dynamic> json) =>
    MedicineClassification(
      json['drugClassificationName'] as String,
      json['generalClassificationName'] as String,
    );

Map<String, dynamic> _$MedicineClassificationToJson(
        MedicineClassification instance) =>
    <String, dynamic>{
      'drugClassificationName': instance.drugClassificationName,
      'generalClassificationName': instance.generalClassificationName,
    };
