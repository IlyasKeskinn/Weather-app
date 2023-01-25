import 'package:location/location.dart';

class LocationHelper {
  double latitude = 0;
  double longitude = 0;

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool _isServiceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _isServiceEnabled = await location.serviceEnabled();
    if (!_isServiceEnabled) {
      _isServiceEnabled = await location.requestService();
      if (!_isServiceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        return;
      }
    }

    _locationData = await location.getLocation();
    latitude = _locationData.latitude!;
    longitude = _locationData.longitude!;
  }
}
