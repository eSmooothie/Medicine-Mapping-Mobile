// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contactDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactDetail _$ContactDetailFromJson(Map<String, dynamic> json) {
  return ContactDetail(
    json['ID'] as String,
    json['CONTACT_ID'] as String,
    json['TYPE'] as String,
    json['DETAIL'] as String,
    json['CREATED_AT'] as String?,
    json['UPDATE_AT'] as String?,
  );
}

Map<String, dynamic> _$ContactDetailToJson(ContactDetail instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'CONTACT_ID': instance.CONTACT_ID,
      'TYPE': instance.TYPE,
      'DETAIL': instance.DETAIL,
      'CREATED_AT': instance.CREATED_AT,
      'UPDATE_AT': instance.UPDATE_AT,
    };
