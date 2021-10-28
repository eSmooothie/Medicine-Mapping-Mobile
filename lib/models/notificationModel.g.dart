// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      json['ID'] as String,
      json['CONTENT'] as String,
      json['TITLE'] as String,
      json['CREATED_AT'] as String,
      json['ADMIN_ID'] as String,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'ID': instance.ID,
      'CONTENT': instance.CONTENT,
      'TITLE': instance.TITLE,
      'CREATED_AT': instance.CREATED_AT,
      'ADMIN_ID': instance.ADMIN_ID,
    };
