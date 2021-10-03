// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medicine _$MedicineFromJson(Map<String, dynamic> json) => Medicine(
      json['id'] as String,
      json['brandName'] as String,
      json['dosage'] as String,
      json['form'] as String,
      json['usage'] as String,
      json['category'] as String,
      (json['genericNames'] as List<dynamic>)
          .map((e) => GenericName.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['medicineClassification'] as List<dynamic>)
          .map(
              (e) => MedicineClassification.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MedicineToJson(Medicine instance) => <String, dynamic>{
      'id': instance.id,
      'brandName': instance.brandName,
      'genericNames': instance.genericNames,
      'medicineClassification': instance.medicineClassification,
      'dosage': instance.dosage,
      'form': instance.form,
      'category': instance.category,
      'usage': instance.usage,
    };
