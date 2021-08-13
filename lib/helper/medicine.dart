import 'package:json_annotation/json_annotation.dart';

part 'medicine.g.dart';

@JsonSerializable()
class Medicine {
  final String id;
  final String brandName;
  final String genericName;
  final String dosage;
  final String dosageForm;
  final bool isOTC;
  final String description;

  Medicine(
    this.id,
    this.brandName,
    this.genericName,
    this.dosage,
    this.dosageForm,
    this.isOTC,
    this.description,
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

  @override
  String toString() {
    // TODO: implement toString
    return "{id:$id brandName:$brandName genericName:$genericName dosage:$dosage dosageForm:$dosageForm isOTC:$isOTC description:$description}";
  }
}
