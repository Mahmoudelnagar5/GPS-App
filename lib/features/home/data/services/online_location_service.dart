import 'dart:async';
import 'package:geolocator/geolocator.dart';

class OnlineLocationService {
  final _locationController = StreamController<Position>.broadcast();
  StreamSubscription<Position>? _positionSubscription;

  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  Stream<Position> get positionStream {
    _positionSubscription ??=
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
          ),
        ).listen((position) {
          _locationController.add(position);
        });

    return _locationController.stream;
  }

  void dispose() {
    _positionSubscription?.cancel();
    _locationController.close();
  }
}
