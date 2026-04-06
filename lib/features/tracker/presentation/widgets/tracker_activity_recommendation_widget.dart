import 'package:flutter/material.dart';
import '../../data/models/accelerometer_models.dart';

class TrackerActivityRecommendationWidget extends StatelessWidget {
  final ActivityRecommendation recommendation;

  const TrackerActivityRecommendationWidget({
    super.key,
    required this.recommendation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      elevation: 8,
      shadowColor: _getActivityColor(
        recommendation.activityType,
      ).withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              _getActivityColor(recommendation.activityType).shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _getActivityColor(recommendation.activityType).shade200,
            width: 1.5,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: _getActivityIcon(recommendation.activityType),
            title: Text(
              recommendation.activityName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
            subtitle: Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _getActivityColor(recommendation.activityType).shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                recommendation.recommendedAccelerometer,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getActivityColor(
                    recommendation.activityType,
                  ).shade800,
                ),
              ),
            ),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            childrenPadding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade200, width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection('Why This Type?', recommendation.reason),
                    const SizedBox(height: 16),
                    Container(
                      height: 1,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey.shade200,
                            Colors.grey.shade300,
                            Colors.grey.shade200,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.settings_suggest_rounded,
                          color: _getActivityColor(
                            recommendation.activityType,
                          ).shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Specifications',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSpecRow(
                      'Recommended Range',
                      '±${recommendation.recommendedRange.toStringAsFixed(0)}g',
                      Icons.straighten_rounded,
                    ),
                    const SizedBox(height: 8),
                    _buildSpecRow(
                      'Sample Rate',
                      '${recommendation.recommendedSampleRate.toStringAsFixed(0)} Hz',
                      Icons.speed_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getActivityIcon(ActivityType type) {
    IconData icon;
    MaterialColor color = _getActivityColor(type);

    switch (type) {
      case ActivityType.accidentDetection:
        icon = Icons.car_crash_rounded;
        break;
      case ActivityType.walkingActivity:
        icon = Icons.directions_walk_rounded;
        break;
      case ActivityType.steppingOverStairs:
        icon = Icons.stairs_rounded;
        break;
      case ActivityType.droppingPhone:
        icon = Icons.phonelink_erase_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.shade400, color.shade600]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }

  MaterialColor _getActivityColor(ActivityType type) {
    switch (type) {
      case ActivityType.accidentDetection:
        return Colors.red;
      case ActivityType.walkingActivity:
        return Colors.green;
      case ActivityType.steppingOverStairs:
        return Colors.blue;
      case ActivityType.droppingPhone:
        return Colors.orange;
    }
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.info_rounded,
              color: _getActivityColor(recommendation.activityType).shade700,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getActivityColor(recommendation.activityType).shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _getActivityColor(recommendation.activityType).shade200,
            ),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getActivityColor(recommendation.activityType).shade50,
            _getActivityColor(recommendation.activityType).shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getActivityColor(recommendation.activityType).shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: _getActivityColor(recommendation.activityType).shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getActivityColor(recommendation.activityType).shade400,
                  _getActivityColor(recommendation.activityType).shade600,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
