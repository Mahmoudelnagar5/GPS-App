import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../data/models/gnss_location.dart';
import '../../data/models/satellite_info.dart';
import '../../data/services/gnss_service.dart';
import '../../data/services/online_location_service.dart';
import '../widgets/location_display_widget.dart';
import '../widgets/satellite_info_widget.dart';
import '../widgets/comparison_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: const Text('GPS App'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeServices,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Initializing GPS services...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red.shade700, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _initializeServices,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _initializeServices,
      child: ListView(
        children: [
          ComparisonWidget(
            onlineLocation: _onlineLocation,
            offlineLocation: _offlineLocation,
          ),
          LocationDisplayWidget(
            onlineLocation: _onlineLocation,
            offlineLocation: _offlineLocation,
          ),
          SatelliteInfoWidget(satellites: _satellites),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
