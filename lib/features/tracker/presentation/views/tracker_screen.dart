import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/models/gnss_location.dart';
import '../../data/models/satellite_info.dart';
import '../../data/services/gnss_service.dart';
import '../../data/services/online_location_service.dart';
import '../widgets/tracker_location_display_widget.dart';
import '../widgets/tracker_satellite_info_widget.dart';
import '../widgets/tracker_comparison_widget.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final _gnssService = GnssService();
  final _onlineService = OnlineLocationService();

  Position? _onlineLocation;
  GnssLocation? _offlineLocation;
  List<SatelliteInfo> _satellites = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final hasPermission = await _requestPermissions();
    if (!hasPermission) {
      setState(() {
        _errorMessage = 'Location permission denied';
        _isLoading = false;
      });
      return;
    }

    _startListening();
    setState(() => _isLoading = false);
  }

  Future<bool> _requestPermissions() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  void _startListening() {
    _gnssService.locationStream.listen((location) {
      setState(() => _offlineLocation = location);
    });

    _gnssService.satelliteStream.listen((satellites) {
      setState(() => _satellites = satellites);
    });

    _onlineService.positionStream.listen((position) {
      setState(() => _onlineLocation = position);
    });
  }

  @override
  void dispose() {
    _gnssService.dispose();
    _onlineService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Location Tracker',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 8,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 28),
            onPressed: _initializeServices,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.teal.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.deepPurple.shade700,
              ),
              strokeWidth: 4,
            ),
            const SizedBox(height: 20),
            Text(
              'Initializing GPS services...',
              style: TextStyle(
                color: Colors.deepPurple.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializeServices,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Retry',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _initializeServices,
      color: Colors.deepPurple.shade700,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          TrackerComparisonWidget(
            onlineLocation: _onlineLocation,
            offlineLocation: _offlineLocation,
          ),
          const SizedBox(height: 16),
          TrackerLocationDisplayWidget(
            onlineLocation: _onlineLocation,
            offlineLocation: _offlineLocation,
          ),
          const SizedBox(height: 16),
          TrackerSatelliteInfoWidget(satellites: _satellites),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
