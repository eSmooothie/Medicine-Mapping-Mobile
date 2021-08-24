import 'package:json_annotation/json_annotation.dart';

part 'pharmacy.g.dart';

@JsonSerializable()
class Pharmacy {
  final String id;
  final String lat;
  final String lng;
  final String name;
  final String address;

  Pharmacy(
    this.id,
    this.lat,
    this.lng,
    this.name,
    this.address,
  );

  factory Pharmacy.fromJson(Map<String, dynamic> json) =>
      _$PharmacyFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "{id:$id, LatLng:($lat, $lng), name:$name, address:$address}";
  }
}
