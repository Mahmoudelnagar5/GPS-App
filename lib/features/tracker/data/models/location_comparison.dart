import 'package:geolocator/geolocator.dart';
import 'gnss_location.dart';

class LocationComparison {
  final Position? onlineLocation;
  final GnssLocation? offlineLocation;
  final double? distanceDifference;
  final DateTime timestamp;

  LocationComparison({
    this.onlineLocation,
    this.offlineLocation,
    this.distanceDifference,
    required this.timestamp,
  });

  bool get hasOnline => onlineLocation != null;
  bool get hasOffline => offlineLocation != null;
  bool get hasBoth => hasOnline && hasOffline;

  String get statusText {
    if (hasBoth) return 'Both Available';
    if (hasOnline) return 'Online Only';
    if (hasOffline) return 'Offline Only';
    return 'No Location';
  }
}
