import 'package:json_annotation/json_annotation.dart';

part 'notificationModel.g.dart';

@JsonSerializable()
class NotificationModel {
  final String ID;
  final String CONTENT;
  final String TITLE;
  final String CREATED_AT;
  final String ADMIN_ID;

  NotificationModel(
    this.ID,
    this.CONTENT,
    this.TITLE,
    this.CREATED_AT,
    this.ADMIN_ID,
  );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
