enum ActivityType {
  accidentDetection,
  walkingActivity,
  steppingOverStairs,
  droppingPhone,
}

class ActivityRecommendation {
  final ActivityType activityType;
  final String activityName;
  final String recommendedAccelerometer;
  final String reason;
  final double recommendedSampleRate;
  final double recommendedRange;

  ActivityRecommendation({
    required this.activityType,
    required this.activityName,
    required this.recommendedAccelerometer,
    required this.reason,
    required this.recommendedSampleRate,
    required this.recommendedRange,
  });

  static List<ActivityRecommendation> getAllRecommendations() {
    return [
      ActivityRecommendation(
        activityType: ActivityType.accidentDetection,
        activityName: 'Accident Detection',
        recommendedAccelerometer: 'High-G Accelerometer (±200g)',
        reason:
            'Car accidents produce very high impact forces (50-200g). Standard accelerometers (±2g to ±16g) will saturate and clip the signal.',
        recommendedSampleRate: 1000.0,
        recommendedRange: 200.0,
      ),
      ActivityRecommendation(
        activityType: ActivityType.walkingActivity,
        activityName: 'Walking Activity',
        recommendedAccelerometer:
            'Standard Low-Power Accelerometer (±2g to ±4g)',
        reason:
            'Walking produces low accelerations (~0.5-2g). Low-power accelerometers are perfect for continuous monitoring with minimal battery drain.',
        recommendedSampleRate: 50.0,
        recommendedRange: 4.0,
      ),
      ActivityRecommendation(
        activityType: ActivityType.steppingOverStairs,
        activityName: 'Stepping Over Stairs',
        recommendedAccelerometer: 'Standard Accelerometer (±8g to ±16g)',
        reason:
            'Stairs produce moderate accelerations (~2-6g). Mid-range accelerometer provides good sensitivity without clipping.',
        recommendedSampleRate: 100.0,
        recommendedRange: 8.0,
      ),
      ActivityRecommendation(
        activityType: ActivityType.droppingPhone,
        activityName: 'Dropping the Phone',
        recommendedAccelerometer: 'High-Range Accelerometer (±16g to ±100g)',
        reason:
            'Phone drops create sudden impacts (10-50g depending on height). High-range accelerometer captures the full impact without saturation.',
        recommendedSampleRate: 200.0,
        recommendedRange: 50.0,
      ),
    ];
  }
}

class AccelerometerInfo {
  final String name;
  final String vendor;
  final double maxRange;
  final double resolution;
  final double power;
  final int minDelay;
  final int maxDelay;

  AccelerometerInfo({
    required this.name,
    required this.vendor,
    required this.maxRange,
    required this.resolution,
    required this.power,
    required this.minDelay,
    required this.maxDelay,
  });

  String get rangeDescription => '±${maxRange.toStringAsFixed(1)}g';
  double get maxSampleRate => minDelay > 0 ? 1000000.0 / minDelay : 0.0;

  String get accelerometerType {
    if (maxRange <= 2.5) return 'Low-Power Accelerometer';
    if (maxRange <= 8) return 'Standard Accelerometer';
    if (maxRange <= 20) return 'High-Range Accelerometer';
    return 'High-G Accelerometer';
  }

  List<String> getSuitableActivities() {
    final activities = <String>[];
    if (maxRange >= 2.0) activities.add('Walking Activity');
    if (maxRange >= 8.0) activities.add('Stepping Over Stairs');
    if (maxRange >= 16.0) activities.add('Dropping Phone');
    if (maxRange >= 50.0) activities.add('Accident Detection');
    return activities;
  }

  String get performanceRating {
    if (maxRange >= 50) return 'Excellent';
    if (maxRange >= 16) return 'Good';
    if (maxRange >= 8) return 'Fair';
    return 'Limited';
  }
}

class AccelerometerData {
  final double x;
  final double y;
  final double z;
  final DateTime timestamp;

  AccelerometerData({
    required this.x,
    required this.y,
    required this.z,
    required this.timestamp,
  });

  double get magnitude {
    final sum = x * x + y * y + z * z;
    return _sqrt(sum);
  }

  String get magnitudeFormatted => '${magnitude.toStringAsFixed(2)}g';

  double _sqrt(double value) {
    if (value < 0) return 0;
    double z = value;
    double x = 1;
    for (int i = 0; i < 10; i++) {
      x = (x + z / x) / 2;
    }
    return x;
  }
}
