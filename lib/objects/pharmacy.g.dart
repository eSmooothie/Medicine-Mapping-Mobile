// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pharmacy _$PharmacyFromJson(Map<String, dynamic> json) {
  return Pharmacy(
    json['id'] as int,
    (json['lat'] as num).toDouble(),
    (json['lng'] as num).toDouble(),
    json['name'] as String,
    json['address'] as String,
  );
}

Map<String, dynamic> _$PharmacyToJson(Pharmacy instance) => <String, dynamic>{
      'id': instance.id,
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
      'address': instance.address,
    };
