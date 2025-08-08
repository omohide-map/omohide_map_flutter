import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../post_view_model.dart';

class LocationDisplay extends StatelessWidget {
  const LocationDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostViewModel>(
      builder: (context, viewModel, child) {
        return Container(
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
                  if (viewModel.isLocationLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: viewModel.getCurrentLocation,
                      tooltip: '位置情報を更新',
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (viewModel.currentPosition != null) ...[
                if (viewModel.currentAddress != null)
                  Text(
                    viewModel.currentAddress!,
                    style: const TextStyle(fontSize: 14),
                  ),
                const SizedBox(height: 4),
                Text(
                  '緯度: ${viewModel.currentPosition!.latitude.toStringAsFixed(6)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '経度: ${viewModel.currentPosition!.longitude.toStringAsFixed(6)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ] else if (!viewModel.isLocationLoading) ...[
                if (viewModel.locationErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      viewModel.locationErrorMessage!,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  )
                else
                  Text(
                    '位置情報を取得できませんでした',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 14,
                    ),
                  ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton.icon(
                      onPressed: viewModel.getCurrentLocation,
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
                    ElevatedButton.icon(
                      onPressed: () => _showMapPicker(context, viewModel),
                      icon: const Icon(Icons.map, size: 16),
                      label: const Text('地図で選択'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                    ),
                    if (!viewModel.isLocationPermissionGranted) ...[
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: viewModel.openLocationSettings,
                        icon: const Icon(Icons.settings, size: 16),
                        label: const Text('設定を開く（位置情報を許可）'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ] else ...[
                const Text('位置情報を取得中...'),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _showMapPicker(
      BuildContext context, PostViewModel viewModel) async {
    final position = await showDialog<Position>(
      context: context,
      builder: (context) => _MapPickerDialog(
        initialPosition: viewModel.currentPosition,
      ),
    );

    if (position != null) {
      viewModel.setPosition(position);
    }
  }
}

class _MapPickerDialog extends HookWidget {
  const _MapPickerDialog({this.initialPosition});

  final Position? initialPosition;

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
