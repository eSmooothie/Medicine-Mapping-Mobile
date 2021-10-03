// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmaInventory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PharmaInventory _$PharmaInventoryFromJson(Map<String, dynamic> json) =>
    PharmaInventory(
      json['id'] as String,
      Medicine.fromJson(json['medicine'] as Map<String, dynamic>),
      json['isStock'] as int,
      (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PharmaInventoryToJson(PharmaInventory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicine': instance.medicine,
      'isStock': instance.isStock,
      'price': instance.price,
    };
