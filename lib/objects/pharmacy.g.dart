// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pharmacy _$PharmacyFromJson(Map<String, dynamic> json) {
  return Pharmacy(
    json['id'] as String,
    json['lat'] as String,
    json['lng'] as String,
    json['name'] as String,
    json['address'] as String,
    json['contactNo'] as String,
  );
}

Map<String, dynamic> _$PharmacyToJson(Pharmacy instance) => <String, dynamic>{
      'id': instance.id,
      'lat': instance.lat,
      'lng': instance.lng,
      'name': instance.name,
      'address': instance.address,
      'contactNo': instance.contactNo,
    };
