import 'package:geolocator/geolocator.dart';

class LocationFetchResult {
  final Position? position;
  final String? address;
  final String? errorMessage;
  final bool isPermissionGranted;
  final bool isPermissionPermanentlyDenied;

  LocationFetchResult({
    required this.position,
    required this.address,
    required this.errorMessage,
    required this.isPermissionGranted,
    required this.isPermissionPermanentlyDenied,
  });
}
