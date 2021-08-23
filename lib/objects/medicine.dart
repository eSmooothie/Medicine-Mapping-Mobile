import 'package:json_annotation/json_annotation.dart';
import 'package:research_mobile_app/objects/genericName.dart';
import 'package:research_mobile_app/objects/medicineClassification.dart';

part 'medicine.g.dart';

@JsonSerializable()
class Medicine {
  final String id;
  final String brandName;
  final List<GenericName> genericNames;
  final List<MedicineClassification> medicineClassification;
  final String dosage;
  final String form;
  final String category;
  final String usage;

  Medicine(
    this.id,
    this.brandName,
    this.dosage,
    this.form,
    this.usage,
    this.category,
    this.genericNames,
    this.medicineClassification,
  );

  /// A necessary factory constructor for creating a new Medicine instance
  /// from a map. Pass the map to the generated `_$MedicineFromJson()` constructor.
  /// The constructor is named after the source class, in this case, Medicine.
  factory Medicine.fromJson(Map<String, dynamic> json) =>
      _$MedicineFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$MedicineToJson`.
  Map<String, dynamic> toJson() => _$MedicineToJson(this);
}
