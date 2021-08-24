import 'package:json_annotation/json_annotation.dart';

part 'medicineClassification.g.dart';

@JsonSerializable()
class MedicineClassification {
  final String drugClassificationName;
  final String generalClassificationName;

  MedicineClassification(
    this.drugClassificationName,
    this.generalClassificationName,
  );

  factory MedicineClassification.fromJson(Map<String, dynamic> json) =>
      _$MedicineClassificationFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineClassificationToJson(this);
}
