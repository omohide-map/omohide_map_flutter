import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  Future<Position?> getCurrentLocation() async {
    try {
      final permissionStatus = await _requestLocationPermission();
      if (!permissionStatus) {
        throw LocationServiceException('位置情報の権限が拒否されました');
      }

      final isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        throw LocationServiceException('位置情報サービスが無効です');
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      return position;
    } catch (e) {
      if (e is LocationServiceException) {
        rethrow;
      }
      throw LocationServiceException('位置情報の取得に失敗しました: ${e.toString()}');
    }
  }

  Future<bool> _requestLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.location.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  Future<bool> checkLocationPermission() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      final placeMarks = await placemarkFromCoordinates(latitude, longitude);
      if (placeMarks.isNotEmpty) {
        final place = placeMarks.first;
        return '${place.locality ?? ''} ${place.subLocality ?? ''}'.trim();
      }
      return '不明な場所';
    } catch (e) {
      return '住所の取得に失敗しました';
    }
  }
}

class LocationServiceException implements Exception {
  final String message;
  LocationServiceException(this.message);

  @override
  String toString() => message;
}
