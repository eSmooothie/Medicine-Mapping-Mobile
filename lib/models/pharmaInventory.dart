import 'package:json_annotation/json_annotation.dart';

import 'medicine.dart';

part 'pharmaInventory.g.dart';

@JsonSerializable()
class PharmaInventory {
  final String id;
  final Medicine medicine;
  final int isStock;
  final double price;

  PharmaInventory(
    this.id,
    this.medicine,
    this.isStock,
    this.price,
  );

  factory PharmaInventory.fromJson(Map<String, dynamic> json) =>
      _$PharmaInventoryFromJson(json);

  Map<String, dynamic> toJson() => _$PharmaInventoryToJson(this);
}
