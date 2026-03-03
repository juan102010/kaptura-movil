import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../../features/home/domain/entities/clock_coords.dart';

enum LocationPermissionState { granted, denied, deniedForever, serviceOff }

class LocationService {
  const LocationService();

  Future<LocationPermissionState> checkPermissionState() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return LocationPermissionState.serviceOff;

    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return LocationPermissionState.granted;
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionState.deniedForever;
    }

    return LocationPermissionState.denied; // denied o denied (sin pedir aún)
  }

  Future<LocationPermissionState> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return LocationPermissionState.serviceOff;

    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return LocationPermissionState.granted;
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionState.deniedForever;
    }

    return LocationPermissionState.denied;
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  /// Devuelve coords obligatorias o lanza excepción con mensaje entendible.
  Future<ClockCoords> getRequiredCoords({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Ubicación desactivada. Actívala para continuar.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Permiso de ubicación denegado.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Permiso de ubicación denegado permanentemente. Habilítalo en Ajustes.',
      );
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: timeout,
    );

    final pos = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    return ClockCoords(
      lat: pos.latitude,
      lng: pos.longitude,
      accuracy: pos.accuracy,
    );
  }
}
