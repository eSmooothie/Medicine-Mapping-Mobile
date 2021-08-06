import 'package:location/location.dart';

class MyLocation {
  static Location location = new Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Future<bool> _check() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  Future<LocationData?> locationData() async {
    if (await _check()) {
      _locationData = await location.getLocation();
      return _locationData;
    }
    return null;
  }
}
