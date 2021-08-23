import 'package:json_annotation/json_annotation.dart';

part 'genericName.g.dart';

@JsonSerializable()
class GenericName {
  final String id;
  final String name;

  GenericName(
    this.id,
    this.name,
  );

  factory GenericName.fromJson(Map<String, dynamic> json) =>
      _$GenericNameFromJson(json);

  Map<String, dynamic> toJson() => _$GenericNameToJson(this);
}
