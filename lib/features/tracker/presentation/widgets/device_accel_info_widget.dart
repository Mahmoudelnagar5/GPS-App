import 'package:flutter/material.dart';
import '../../data/models/accelerometer_models.dart';

class DeviceAccelInfoWidget extends StatelessWidget {
  final AccelerometerInfo info;

  const DeviceAccelInfoWidget({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.smartphone, color: Colors.blue.shade700, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Device Accelerometer',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Type', info.accelerometerType, Icons.category),
            _buildInfoRow('Range', info.rangeDescription, Icons.straighten),
            _buildInfoRow(
              'Max Sample Rate',
              '${info.maxSampleRate.toStringAsFixed(0)} Hz',
              Icons.speed,
            ),
            _buildInfoRow(
              'Performance',
              info.performanceRating,
              Icons.star,
              color: _getRatingColor(info.performanceRating),
            ),
            const Divider(height: 24),
            _buildSuitableActivities(info.getSuitableActivities()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuitableActivities(List<String> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Suitable For:',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        if (activities.isEmpty)
          const Text(
            'Limited functionality',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: activities
                .map(
                  (activity) => Chip(
                    label: Text(activity, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.green.shade50,
                    labelStyle: TextStyle(color: Colors.green.shade700),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Color _getRatingColor(String rating) {
    switch (rating) {
      case 'Excellent':
        return Colors.green;
      case 'Good':
        return Colors.blue;
      case 'Fair':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}
