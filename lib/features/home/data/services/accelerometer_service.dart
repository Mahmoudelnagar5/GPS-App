import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/accelerometer_models.dart';

class AccelerometerService {
  final _accelerometerController =
      StreamController<AccelerometerData>.broadcast();
  StreamSubscription? _subscription;

  Stream<AccelerometerData> get accelerometerStream =>
      _accelerometerController.stream;

  void startListening() {
    _subscription = accelerometerEventStream().listen((
      AccelerometerEvent event,
    ) {
      final data = AccelerometerData(
        x: event.x / 9.81,
        y: event.y / 9.81,
        z: event.z / 9.81,
        timestamp: DateTime.now(),
      );
      _accelerometerController.add(data);
    });
  }

  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
  }

  void dispose() {
    stopListening();
    _accelerometerController.close();
  }

  static AccelerometerInfo getDeviceAccelerometer() {
    return AccelerometerInfo(
      name: 'Device Accelerometer',
      vendor: 'System',
      maxRange: 16.0,
      resolution: 0.001,
      power: 0.23,
      minDelay: 10000,
      maxDelay: 200000,
    );
  }
}
