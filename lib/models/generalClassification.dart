import 'package:json_annotation/json_annotation.dart';

part 'generalClassification.g.dart';

@JsonSerializable()
class GeneralClassification {
  final String ID;
  final String NAME;

  GeneralClassification(
    this.ID,
    this.NAME,
  );

  factory GeneralClassification.fromJson(Map<String, dynamic> json) =>
      _$GeneralClassificationFromJson(json);

  Map<String, dynamic> toJson() => _$GeneralClassificationToJson(this);
}
