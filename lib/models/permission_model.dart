class PermissionStatusResult {
  final bool isPermissionGranted;
  final bool isPermissionPermanentlyDenied;

  PermissionStatusResult({
    required this.isPermissionGranted,
    required this.isPermissionPermanentlyDenied,
  });
}
