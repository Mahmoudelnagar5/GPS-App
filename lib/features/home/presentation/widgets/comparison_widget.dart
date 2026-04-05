import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/gnss_location.dart';
import 'dart:math';

class ComparisonWidget extends StatelessWidget {
  final Position? onlineLocation;
  final GnssLocation? offlineLocation;

  const ComparisonWidget({
    super.key,
    this.onlineLocation,
    this.offlineLocation,
  });

  @override
  Widget build(BuildContext context) {
    final hasOnline = onlineLocation != null;
    final hasOffline = offlineLocation != null;
    final hasBoth = hasOnline && hasOffline;

    double? distanceDiff;
    if (hasBoth) {
      distanceDiff = _calculateDistance(
        onlineLocation!.latitude,
        onlineLocation!.longitude,
        offlineLocation!.latitude,
        offlineLocation!.longitude,
      );
    }

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Online vs Offline Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStatusRow(hasOnline, hasOffline),
            if (hasBoth) ...[
              const Divider(height: 24),
              _buildComparisonData(distanceDiff),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(bool hasOnline, bool hasOffline) {
    return Row(
      children: [
        _buildStatusIndicator('Online', hasOnline),
        const SizedBox(width: 16),
        _buildStatusIndicator('Offline', hasOffline),
      ],
    );
  }

  Widget _buildStatusIndicator(String label, bool isAvailable) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: isAvailable ? Colors.green : Colors.red,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isAvailable ? Colors.green.shade700 : Colors.red.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonData(double? distance) {
    if (distance == null) return const SizedBox();

    final accuracyDiff = (onlineLocation!.accuracy - offlineLocation!.accuracy)
        .abs();
    final altitudeDiff = (onlineLocation!.altitude - offlineLocation!.altitude)
        .abs();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Difference Metrics',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        _buildMetricRow(
          'Horizontal Distance',
          '${distance.toStringAsFixed(2)} m',
          distance,
          threshold: 10.0,
        ),
        _buildMetricRow(
          'Accuracy Difference',
          '${accuracyDiff.toStringAsFixed(2)} m',
          accuracyDiff,
          threshold: 5.0,
        ),
        _buildMetricRow(
          'Altitude Difference',
          '${altitudeDiff.toStringAsFixed(2)} m',
          altitudeDiff,
          threshold: 15.0,
        ),
      ],
    );
  }

  Widget _buildMetricRow(
    String label,
    String value,
    double metric, {
    required double threshold,
  }) {
    final isGood = metric <= threshold;
    final color = isGood ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isGood ? Icons.check_circle : Icons.warning,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000;

    final lat1Rad = lat1 * (pi / 180);
    final lat2Rad = lat2 * (pi / 180);
    final deltaLat = (lat2 - lat1) * (pi / 180);
    final deltaLon = (lon2 - lon1) * (pi / 180);

    final a =
        pow(sin(deltaLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(deltaLon / 2), 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }
}
