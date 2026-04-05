import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/gnss_location.dart';

class LocationDisplayWidget extends StatelessWidget {
  final Position? onlineLocation;
  final GnssLocation? offlineLocation;

  const LocationDisplayWidget({
    super.key,
    this.onlineLocation,
    this.offlineLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildLocationSection('Online (Network + GPS)', onlineLocation),
            const Divider(height: 24),
            _buildOfflineSection('Offline (GNSS)', offlineLocation),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection(String title, Position? location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (location != null) ...[
          _buildInfoRow('Latitude', location.latitude.toStringAsFixed(6)),
          _buildInfoRow('Longitude', location.longitude.toStringAsFixed(6)),
          _buildInfoRow(
            'Altitude',
            '${location.altitude.toStringAsFixed(1)} m',
          ),
          _buildInfoRow(
            'Accuracy',
            '${location.accuracy.toStringAsFixed(1)} m',
          ),
          _buildInfoRow('Speed', '${location.speed.toStringAsFixed(1)} m/s'),
        ] else
          const Text(
            'No location available',
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildOfflineSection(String title, GnssLocation? location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (location != null) ...[
          _buildInfoRow('Latitude', location.latitude.toStringAsFixed(6)),
          _buildInfoRow('Longitude', location.longitude.toStringAsFixed(6)),
          _buildInfoRow(
            'Altitude',
            '${location.altitude.toStringAsFixed(1)} m',
          ),
          _buildInfoRow(
            'Accuracy',
            '${location.accuracy.toStringAsFixed(1)} m',
          ),
          if (location.speed != null)
            _buildInfoRow('Speed', '${location.speed!.toStringAsFixed(1)} m/s'),
        ] else
          const Text(
            'No location available',
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
