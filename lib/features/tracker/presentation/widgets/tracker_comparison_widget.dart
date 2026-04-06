import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/gnss_location.dart';
import 'dart:math';

class TrackerComparisonWidget extends StatelessWidget {
  final Position? onlineLocation;
  final GnssLocation? offlineLocation;

  const TrackerComparisonWidget({
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
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      elevation: 12,
      shadowColor: Colors.deepPurple.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.compare_arrows_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Location Comparison',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildStatusRow(hasOnline, hasOffline),
              if (hasBoth) ...[
                const SizedBox(height: 20),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.5),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildComparisonData(distanceDiff),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(bool hasOnline, bool hasOffline) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildStatusIndicator('Online', hasOnline)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatusIndicator('Offline', hasOffline)),
      ],
    );
  }

  Widget _buildStatusIndicator(String label, bool isAvailable) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: isAvailable ? Colors.teal.shade300 : Colors.red.shade300,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: isAvailable
                      ? Colors.teal.withOpacity(0.6)
                      : Colors.red.withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        _buildMetricRow(
          'Horizontal Distance',
          '${distance.toStringAsFixed(2)} m',
          distance,
          threshold: 10.0,
          icon: Icons.swap_horiz_rounded,
        ),
        _buildMetricRow(
          'Accuracy Difference',
          '${accuracyDiff.toStringAsFixed(2)} m',
          accuracyDiff,
          threshold: 5.0,
          icon: Icons.gps_fixed_rounded,
        ),
        _buildMetricRow(
          'Altitude Difference',
          '${altitudeDiff.toStringAsFixed(2)} m',
          altitudeDiff,
          threshold: 15.0,
          icon: Icons.height_rounded,
        ),
      ],
    );
  }

  Widget _buildMetricRow(
    String label,
    String value,
    double metric, {
    required double threshold,
    required IconData icon,
  }) {
    final isGood = metric <= threshold;
    final color = isGood ? Colors.teal.shade300 : Colors.orange.shade300;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isGood ? Icons.check_circle_rounded : Icons.warning_rounded,
            color: color,
            size: 26,
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
