import 'package:flutter/material.dart';
import '../../data/models/accelerometer_models.dart';

class ActivityRecommendationWidget extends StatelessWidget {
  final ActivityRecommendation recommendation;

  const ActivityRecommendationWidget({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        leading: _getActivityIcon(recommendation.activityType),
        title: Text(
          recommendation.activityName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          recommendation.recommendedAccelerometer,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Why This Type?', recommendation.reason),
                const SizedBox(height: 12),
                _buildSpecRow(
                  'Recommended Range',
                  '±${recommendation.recommendedRange.toStringAsFixed(0)}g',
                ),
                _buildSpecRow(
                  'Sample Rate',
                  '${recommendation.recommendedSampleRate.toStringAsFixed(0)} Hz',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getActivityIcon(ActivityType type) {
    IconData icon;
    Color color;

    switch (type) {
      case ActivityType.accidentDetection:
        icon = Icons.car_crash;
        color = Colors.red;
        break;
      case ActivityType.walkingActivity:
        icon = Icons.directions_walk;
        color = Colors.green;
        break;
      case ActivityType.steppingOverStairs:
        icon = Icons.stairs;
        color = Colors.blue;
        break;
      case ActivityType.droppingPhone:
        icon = Icons.phonelink_erase;
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade700,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
