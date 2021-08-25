import 'package:json_annotation/json_annotation.dart';

part 'generalClassification.g.dart';

@JsonSerializable()
class GeneralClassification {
  // ignore: non_constant_identifier_names
  final String ID;
  // ignore: non_constant_identifier_names
  final String NAME;

  GeneralClassification(
    this.ID,
    this.NAME,
  );

  factory GeneralClassification.fromJson(Map<String, dynamic> json) =>
      _$GeneralClassificationFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralClassificationToJson(this);
}
