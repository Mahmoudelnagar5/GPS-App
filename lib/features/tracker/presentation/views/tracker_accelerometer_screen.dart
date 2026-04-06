import 'package:flutter/material.dart';
import '../../data/models/accelerometer_models.dart';
import '../../data/services/accelerometer_service.dart';
import '../widgets/tracker_device_accel_info_widget.dart';
import '../widgets/tracker_activity_recommendation_widget.dart';
import '../widgets/tracker_live_accel_data_widget.dart';

class TrackerAccelerometerScreen extends StatefulWidget {
  const TrackerAccelerometerScreen({super.key});

  @override
  State<TrackerAccelerometerScreen> createState() =>
      _TrackerAccelerometerScreenState();
}

class _TrackerAccelerometerScreenState
    extends State<TrackerAccelerometerScreen> {
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
        title: const Text(
          'Accelerometer Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.purple.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 8,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(
                _isListening
                    ? Icons.pause_circle_rounded
                    : Icons.play_circle_rounded,
                size: 32,
              ),
              onPressed: _isListening ? _stopListening : _startListening,
              tooltip: _isListening ? 'Pause' : 'Resume',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.deepPurple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TrackerLiveAccelDataWidget(data: _currentData),
            const SizedBox(height: 16),
            TrackerDeviceAccelInfoWidget(info: _deviceInfo),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade100, Colors.purple.shade100],
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.deepPurple.shade300, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.recommend_rounded,
                        color: Colors.deepPurple.shade700,
                        size: 26,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Activity Recommendations',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap each activity to see details',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.deepPurple.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...recommendations.map(
              (rec) => TrackerActivityRecommendationWidget(recommendation: rec),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
