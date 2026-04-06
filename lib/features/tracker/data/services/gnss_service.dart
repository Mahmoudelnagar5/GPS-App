import 'dart:async';
import 'package:flutter/services.dart';
import '../models/gnss_location.dart';
import '../models/satellite_info.dart';

class GnssService {
  static const _channel = MethodChannel('com.example.gps_app/gnss');
  static const _eventChannel = EventChannel('com.example.gps_app/gnss_stream');

  Stream<GnssLocation>? _locationStream;
  Stream<List<SatelliteInfo>>? _satelliteStream;

  final _locationController = StreamController<GnssLocation>.broadcast();
  final _satelliteController =
      StreamController<List<SatelliteInfo>>.broadcast();

  StreamSubscription? _eventSubscription;

  Future<bool> checkPermissions() async {
    try {
      final result = await _channel.invokeMethod('checkPermissions');
      return result as bool;
    } catch (e) {
      return false;
    }
  }

  Future<GnssLocation?> getCurrentLocation() async {
    try {
      final result = await _channel.invokeMethod('getCurrentLocation');
      if (result != null) {
        return GnssLocation.fromMap(result as Map);
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  Stream<GnssLocation> get locationStream {
    if (_locationStream == null) {
      _startListening();
      _locationStream = _locationController.stream;
    }
    return _locationStream!;
  }

  Stream<List<SatelliteInfo>> get satelliteStream {
    if (_satelliteStream == null) {
      _startListening();
      _satelliteStream = _satelliteController.stream;
    }
    return _satelliteStream!;
  }

  void _startListening() {
    _eventSubscription ??= _eventChannel.receiveBroadcastStream().listen((
      event,
    ) {
      if (event is Map) {
        final type = event['type'] as String?;

        if (type == 'location') {
          final location = GnssLocation.fromMap(event);
          _locationController.add(location);
        } else if (type == 'satellites') {
          final satellitesList = event['satellites'] as List;
          final satellites = satellitesList
              .map((sat) => SatelliteInfo.fromMap(sat as Map))
              .toList();
          _satelliteController.add(satellites);
        }
      }
    });
  }

  void dispose() {
    _eventSubscription?.cancel();
    _locationController.close();
    _satelliteController.close();
  }
}
