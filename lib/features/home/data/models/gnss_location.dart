import 'dart:math';

class GnssLocation {
  final double latitude;
  final double longitude;
  final double altitude;
  final double accuracy;
  final double? speed;
  final double? bearing;
  final DateTime timestamp;

  GnssLocation({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.accuracy,
    this.speed,
    this.bearing,
    required this.timestamp,
  });

  factory GnssLocation.fromMap(Map<dynamic, dynamic> map) {
    return GnssLocation(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      altitude: (map['altitude'] as num).toDouble(),
      accuracy: (map['accuracy'] as num).toDouble(),
      speed: map['speed'] != null ? (map['speed'] as num).toDouble() : null,
      bearing: map['bearing'] != null
          ? (map['bearing'] as num).toDouble()
          : null,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  double distanceTo(GnssLocation other) {
    const double earthRadius = 6371000;

    final lat1Rad = latitude * (pi / 180);
    final lat2Rad = other.latitude * (pi / 180);
    final deltaLat = (other.latitude - latitude) * (pi / 180);
    final deltaLon = (other.longitude - longitude) * (pi / 180);

    final a = pow(sin(deltaLat / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(deltaLon / 2), 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }
}

