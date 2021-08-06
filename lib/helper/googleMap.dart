import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class Map {
  late GoogleMapController mapController;
  late String _mapStyle;
  final LatLng _center = const LatLng(8.2280, 124.2452);
  bool darkMode = false;

  Map() {
    String loadMapStyle =
        darkMode ? 'assets/dark_mapStyle.txt' : 'assets/default_mapStyle.txt';
    rootBundle.loadString(loadMapStyle).then((string) {
      _mapStyle = string;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  // The larger the value of zoom the more it is closer to the map.
  dynamic initMap({double zoom = 12.0}) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: zoom),
      zoomControlsEnabled: false,
    );
  }
}
