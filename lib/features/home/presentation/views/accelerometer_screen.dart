import 'package:flutter/material.dart';
import '../../data/models/accelerometer_models.dart';
import '../../data/services/accelerometer_service.dart';
import '../widgets/device_accel_info_widget.dart';
import '../widgets/activity_recommendation_widget.dart';
import '../widgets/live_accel_data_widget.dart';

class AccelerometerScreen extends StatefulWidget {
  const AccelerometerScreen({super.key});

  @override
  State<AccelerometerScreen> createState() => _AccelerometerScreenState();
}

class _AccelerometerScreenState extends State<AccelerometerScreen> {
  final _accelerometerService = AccelerometerService();
  AccelerometerData? _currentData;
  late AccelerometerInfo _deviceInfo;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _deviceInfo = AccelerometerService.getDeviceAccelerometer();
    _startListening();
  }

  void _startListening() {
    setState(() => _isListening = true);
    _accelerometerService.startListening();
    _accelerometerService.accelerometerStream.listen((data) {
      if (mounted) {
        setState(() => _currentData = data);
      }
    });
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _accelerometerService.stopListening();
  }

  @override
  void dispose() {
    _accelerometerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = ActivityRecommendation.getAllRecommendations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accelerometer Analysis'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.pause : Icons.play_arrow),
            onPressed: _isListening ? _stopListening : _startListening,
            tooltip: _isListening ? 'Pause' : 'Resume',
          ),
        ],
      ),
      body: ListView(
        children: [
          LiveAccelDataWidget(data: _currentData),
          DeviceAccelInfoWidget(info: _deviceInfo),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recommended Accelerometers by Activity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap each activity to see details',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          ...recommendations.map(
            (rec) => ActivityRecommendationWidget(recommendation: rec),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
