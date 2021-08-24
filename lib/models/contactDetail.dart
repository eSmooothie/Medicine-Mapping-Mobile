import 'package:json_annotation/json_annotation.dart';

part 'contactDetail.g.dart';

@JsonSerializable()
class ContactDetail {
  final String ID;
  final String CONTACT_ID;
  final String TYPE;
  final String DETAIL;
  final String? CREATED_AT;
  final String? UPDATE_AT;

  ContactDetail(
    this.ID,
    this.CONTACT_ID,
    this.TYPE,
    this.DETAIL,
    this.CREATED_AT,
    this.UPDATE_AT,
  );

  factory ContactDetail.fromJson(Map<String, dynamic> json) =>
      _$ContactDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ContactDetailToJson(this);
}
