import 'package:json_annotation/json_annotation.dart';

part 'contactDetail.g.dart';

@JsonSerializable()
class ContactDetail {
  // ignore: non_constant_identifier_names
  final String ID;
  // ignore: non_constant_identifier_names
  final String CONTACT_ID;
  // ignore: non_constant_identifier_names
  final String TYPE;
  // ignore: non_constant_identifier_names
  final String DETAIL;
  // ignore: non_constant_identifier_names
  final String? CREATED_AT;
  // ignore: non_constant_identifier_names
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
