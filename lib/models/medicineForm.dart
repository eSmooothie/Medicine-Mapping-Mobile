import 'package:json_annotation/json_annotation.dart';

part 'medicineForm.g.dart';

@JsonSerializable()
class MedicineForm {
  final String ID;
  final String NAME;

  MedicineForm(
    this.ID,
    this.NAME,
  );

  factory MedicineForm.fromJson(Map<String, dynamic> json) =>
      _$MedicineFormFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineFormToJson(this);
}
