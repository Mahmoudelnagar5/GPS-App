import 'package:flutter/material.dart';
import '../../data/models/satellite_info.dart';

class SatelliteInfoWidget extends StatelessWidget {
  final List<SatelliteInfo> satellites;

  const SatelliteInfoWidget({super.key, required this.satellites});

  @override
  Widget build(BuildContext context) {
    final gpsCount = satellites.where((s) => s.constellation == 'GPS').length;
    final glonassCount = satellites
        .where((s) => s.constellation == 'GLONASS')
        .length;
    final beidouCount = satellites
        .where((s) => s.constellation == 'BEIDOU')
        .length;
    final usedCount = satellites.where((s) => s.usedInFix).length;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Satellite Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSummary(gpsCount, glonassCount, beidouCount, usedCount),
            const Divider(height: 24),
            const Text(
              'Satellites in View',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 8),
            if (satellites.isEmpty)
              const Text(
                'No satellites detected',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...satellites.take(15).map((sat) => _buildSatelliteRow(sat)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(int gps, int glonass, int beidou, int used) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildChip('Total', satellites.length.toString(), Colors.blue),
        _buildChip('Used', used.toString(), Colors.green),
        _buildChip('GPS', gps.toString(), Colors.orange),
        _buildChip('GLONASS', glonass.toString(), Colors.red),
        _buildChip('BeiDou', beidou.toString(), Colors.purple),
      ],
    );
  }

  Widget _buildChip(String label, String value, Color color) {
    return Chip(
      label: Text('$label: $value'),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildSatelliteRow(SatelliteInfo sat) {
    final signalStrength = sat.cn0DbHz;
    final signalColor = signalStrength > 35
        ? Colors.green
        : signalStrength > 25
        ? Colors.orange
        : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: sat.usedInFix ? Colors.green.shade200 : Colors.grey.shade300,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getConstellationColor(sat.constellation).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              sat.constellation,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: _getConstellationColor(sat.constellation),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${sat.svid}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.signal_cellular_alt,
                          size: 16,
                          color: signalColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${sat.cn0DbHz.toStringAsFixed(1)} dB',
                          style: TextStyle(
                            color: signalColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'El: ${sat.elevation.toStringAsFixed(1)}° | Az: ${sat.azimuth.toStringAsFixed(1)}°',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          if (sat.usedInFix)
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.check, size: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Color _getConstellationColor(String constellation) {
    switch (constellation) {
      case 'GPS':
        return Colors.orange;
      case 'GLONASS':
        return Colors.red;
      case 'BEIDOU':
        return Colors.purple;
      case 'GALILEO':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
