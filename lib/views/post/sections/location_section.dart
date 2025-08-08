import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:omohide_map_flutter/services/location_service.dart';

class LocationSection extends HookWidget {
  const LocationSection({
    super.key,
    required this.position,
    required this.address,
    required this.onRefetch,
    required this.isLocationPermissionGranted,
    required this.openLocationSettings,
  });

  final ValueNotifier<Position?> position;
  final ValueNotifier<String?> address;
  final VoidCallback onRefetch;
  final bool isLocationPermissionGranted;
  final VoidCallback openLocationSettings;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.blue.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                '現在地',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh, size: 20),
                onPressed: () {
                  isLoading.value = true;
                  onRefetch();
                  isLoading.value = false;
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (isLoading.value)
            const Center(child: CircularProgressIndicator())
          else if (position.value != null && address.value != null)
            _LocationDisplay(
              position: position,
              address: address,
            )
          else
            _LocationErrorDisplay(
              isLoading: isLoading,
              onRefetch: onRefetch,
              position: position,
              address: address,
              isLocationPermissionGranted: isLocationPermissionGranted,
              openLocationSettings: openLocationSettings,
            ),
        ],
      ),
    );
  }
}

class _LocationDisplay extends StatelessWidget {
  const _LocationDisplay({
    required this.position,
    required this.address,
  });

  final ValueNotifier<Position?> position;
  final ValueNotifier<String?> address;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(address.value ?? '位置情報を取得できませんでした'),
        _SelectFromMapButton(
          position: position,
          address: address,
        ),
      ],
    );
  }
}

class _LocationErrorDisplay extends StatelessWidget {
  const _LocationErrorDisplay({
    required this.isLoading,
    required this.position,
    required this.address,
    required this.isLocationPermissionGranted,
    required this.onRefetch,
    required this.openLocationSettings,
  });

  final ValueNotifier<bool> isLoading;
  final ValueNotifier<Position?> position;
  final ValueNotifier<String?> address;
  final bool isLocationPermissionGranted;

  final VoidCallback onRefetch;
  final VoidCallback openLocationSettings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('位置情報を取得できませんでした'),
        ElevatedButton.icon(
          onPressed: () {
            isLoading.value = true;
            onRefetch();
            isLoading.value = false;
          },
          icon: const Icon(Icons.location_searching, size: 16),
          label: const Text('再取得'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
        ),
        const SizedBox(height: 8),
        _SelectFromMapButton(
          position: position,
          address: address,
        ),
        const SizedBox(height: 8),
        if (!isLocationPermissionGranted)
          ElevatedButton.icon(
            onPressed: openLocationSettings,
            icon: const Icon(Icons.settings, size: 16),
            label: const Text('設定を開く'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
      ],
    );
  }
}

class _SelectFromMapButton extends HookWidget {
  const _SelectFromMapButton({
    required this.position,
    required this.address,
  });

  final ValueNotifier<Position?> position;
  final ValueNotifier<String?> address;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final newPosition = await showDialog<Position>(
          context: context,
          builder: (context) => _MapPickerDialog(),
        );

        if (newPosition != null) {
          position.value = newPosition;
          final service = LocationService();
          final newAddress = await service.getAddressFromCoordinates(
            newPosition.latitude,
            newPosition.longitude,
          );
          address.value = newAddress;
        }
      },
      icon: const Icon(Icons.map, size: 16),
      label: const Text('地図で選択'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}

class _MapPickerDialog extends HookWidget {
  const _MapPickerDialog();

  @override
  Widget build(BuildContext context) {
    final mapController = useMemoized(() => MapController());
    final selectedLocation = useState<LatLng?>(null);
    final isLoading = useState(false);

    useEffect(() {
      return () => mapController.dispose();
    }, []);

    void onMapTap(TapPosition tapPosition, LatLng position) {
      selectedLocation.value = position;
    }

    Future<void> goToCurrentLocation() async {
      isLoading.value = true;

      try {
        final position = await Geolocator.getCurrentPosition();
        final latLng = LatLng(position.latitude, position.longitude);

        selectedLocation.value = latLng;
        mapController.move(latLng, 15.0);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('現在地を取得できませんでした: $e')),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    final center =
        selectedLocation.value ?? const LatLng(35.6762, 139.6503); // 東京

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.map, color: Colors.white),
                const SizedBox(width: 8),
                const Text(
                  '場所を選択',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 400,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 15.0,
                    onTap: onMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.omohide_map_flutter',
                    ),
                    if (selectedLocation.value != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: selectedLocation.value!,
                            width: 80,
                            height: 80,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: isLoading.value ? null : goToCurrentLocation,
                    child: isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.my_location),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('キャンセル'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: selectedLocation.value != null
                      ? () {
                          Navigator.of(context).pop(
                            Position(
                              latitude: selectedLocation.value!.latitude,
                              longitude: selectedLocation.value!.longitude,
                              timestamp: DateTime.now(),
                              accuracy: 0,
                              altitude: 0,
                              altitudeAccuracy: 0,
                              heading: 0,
                              headingAccuracy: 0,
                              speed: 0,
                              speedAccuracy: 0,
                            ),
                          );
                        }
                      : null,
                  child: const Text('選択'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
