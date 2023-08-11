import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

enum LocationPermissionStatus {
  Always,
  WhileInUse,
  Denied,
  DeniedForever,
  UnableToDetermine,
}

class QiblahCompassProvider extends ChangeNotifier {
  LocationPermissionStatus _permissionStatus =
      LocationPermissionStatus.UnableToDetermine;
  bool _enabled = false;

  LocationPermissionStatus get permissionStatus => _permissionStatus;
  bool get enabled => _enabled;

  final StreamController<LocationStatus> _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  Stream<LocationStatus> get stream => _locationStreamController.stream;

  Future<void> checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();

    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final updatedStatus = await FlutterQiblah.checkLocationStatus();
      _permissionStatus = _convertToPermissionStatus(updatedStatus.status);
      _enabled = updatedStatus.enabled;
      _locationStreamController.sink.add(updatedStatus);
    } else {
      _permissionStatus = _convertToPermissionStatus(locationStatus.status);
      _enabled = locationStatus.enabled;
      _locationStreamController.sink.add(locationStatus);
    }

    notifyListeners();
  }

  LocationPermissionStatus _convertToPermissionStatus(
      LocationPermission status) {
    switch (status) {
      case LocationPermission.always:
        return LocationPermissionStatus.Always;
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.WhileInUse;
      case LocationPermission.denied:
        return LocationPermissionStatus.Denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.DeniedForever;
      default:
        return LocationPermissionStatus.UnableToDetermine;
    }
  }

  @override
  void dispose() {
    _locationStreamController.close();
    FlutterQiblah().dispose();
    super.dispose();
  }
}
