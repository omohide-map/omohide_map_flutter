import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerDialog extends HookWidget {
  final Position? initialPosition;

  const MapPickerDialog({
    super.key,
    this.initialPosition,
  });

  @override
  Widget build(BuildContext context) {
    final mapController = useMemoized(() => MapController());
    final selectedLocation = useState<LatLng?>(
      initialPosition != null
          ? LatLng(initialPosition!.latitude, initialPosition!.longitude)
          : null,
    );
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

    final center = selectedLocation.value ??
        (initialPosition != null
            ? LatLng(initialPosition!.latitude, initialPosition!.longitude)
            : const LatLng(35.6762, 139.6503)); // 東京をデフォルトに

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
          if (selectedLocation.value != null)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '緯度: ${selectedLocation.value!.latitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    '経度: ${selectedLocation.value!.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(fontSize: 12),
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
                          Navigator.of(context).pop(Position(
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
                          ));
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
