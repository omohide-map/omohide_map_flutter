import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../post_view_model.dart';
import 'map_picker_dialog.dart';

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
                  Icon(Icons.location_on, color: Colors.blue.shade700, size: 20),
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
                Text(
                  '位置情報を取得できませんでした',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: viewModel.getCurrentLocation,
                        icon: const Icon(Icons.location_searching, size: 16),
                        label: const Text('再取得'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showMapPicker(context, viewModel),
                        icon: const Icon(Icons.map, size: 16),
                        label: const Text('地図で選択'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
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

  Future<void> _showMapPicker(BuildContext context, PostViewModel viewModel) async {
    final position = await showDialog<Position>(
      context: context,
      builder: (context) => MapPickerDialog(
        initialPosition: viewModel.currentPosition,
      ),
    );

    if (position != null) {
      viewModel.setPosition(position);
    }
  }
}
