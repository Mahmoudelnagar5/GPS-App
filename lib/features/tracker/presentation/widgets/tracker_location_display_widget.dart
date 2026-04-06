import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/gnss_location.dart';

class TrackerLocationDisplayWidget extends StatelessWidget {
  final Position? onlineLocation;
  final GnssLocation? offlineLocation;

  const TrackerLocationDisplayWidget({
    super.key,
    this.onlineLocation,
    this.offlineLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      elevation: 12,
      shadowColor: Colors.teal.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.teal.shade50],
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
                      gradient: LinearGradient(
                        colors: [Colors.teal.shade400, Colors.teal.shade600],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Location Data',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildLocationSection('Online (Network + GPS)', onlineLocation),
              const SizedBox(height: 16),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.shade100,
                      Colors.teal.shade300,
                      Colors.teal.shade100,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              _buildOfflineSection('Offline (GNSS)', offlineLocation),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection(String title, Position? location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.cloud_rounded,
                color: Colors.deepPurple.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (location != null) ...[
          _buildInfoRow(
            'Latitude',
            location.latitude.toStringAsFixed(6),
            Icons.north_rounded,
            Colors.deepPurple,
          ),
          _buildInfoRow(
            'Longitude',
            location.longitude.toStringAsFixed(6),
            Icons.east_rounded,
            Colors.deepPurple,
          ),
          _buildInfoRow(
            'Altitude',
            '${location.altitude.toStringAsFixed(1)} m',
            Icons.terrain_rounded,
            Colors.teal,
          ),
          _buildInfoRow(
            'Accuracy',
            '${location.accuracy.toStringAsFixed(1)} m',
            Icons.gps_fixed_rounded,
            Colors.orange,
          ),
          _buildInfoRow(
            'Speed',
            '${location.speed.toStringAsFixed(1)} m/s',
            Icons.speed_rounded,
            Colors.indigo,
          ),
        ] else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.grey.shade600),
                const SizedBox(width: 12),
                Text(
                  'No location available',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOfflineSection(String title, GnssLocation? location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.satellite_alt_rounded,
                color: Colors.teal.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.teal.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (location != null) ...[
          _buildInfoRow(
            'Latitude',
            location.latitude.toStringAsFixed(6),
            Icons.north_rounded,
            Colors.deepPurple,
          ),
          _buildInfoRow(
            'Longitude',
            location.longitude.toStringAsFixed(6),
            Icons.east_rounded,
            Colors.deepPurple,
          ),
          _buildInfoRow(
            'Altitude',
            '${location.altitude.toStringAsFixed(1)} m',
            Icons.terrain_rounded,
            Colors.teal,
          ),
          _buildInfoRow(
            'Accuracy',
            '${location.accuracy.toStringAsFixed(1)} m',
            Icons.gps_fixed_rounded,
            Colors.orange,
          ),
          if (location.speed != null)
            _buildInfoRow(
              'Speed',
              '${location.speed!.toStringAsFixed(1)} m/s',
              Icons.speed_rounded,
              Colors.indigo,
            ),
        ] else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.grey.shade600),
                const SizedBox(width: 12),
                Text(
                  'No location available',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon,
    MaterialColor iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.shade100, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: iconColor.shade100.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor.shade700, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: iconColor.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
