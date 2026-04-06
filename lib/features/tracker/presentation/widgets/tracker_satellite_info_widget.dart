import 'package:flutter/material.dart';
import '../../data/models/satellite_info.dart';

class TrackerSatelliteInfoWidget extends StatelessWidget {
  final List<SatelliteInfo> satellites;

  const TrackerSatelliteInfoWidget({super.key, required this.satellites});

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
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      elevation: 12,
      shadowColor: Colors.indigo.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.indigo.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.shade400,
                          Colors.indigo.shade700,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.satellite_alt_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Satellite Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSummary(gpsCount, glonassCount, beidouCount, usedCount),
              const SizedBox(height: 16),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.shade100,
                      Colors.indigo.shade300,
                      Colors.indigo.shade100,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_rounded,
                      color: Colors.indigo.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Satellites in View',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (satellites.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'No satellites detected',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...satellites.map((sat) => _buildSatelliteRow(sat)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(int gps, int glonass, int beidou, int used) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildChip(
          'Total',
          satellites.length.toString(),
          Colors.indigo,
          Icons.satellite_rounded,
        ),
        _buildChip(
          'Used',
          used.toString(),
          Colors.teal,
          Icons.check_circle_rounded,
        ),
        _buildChip(
          'GPS',
          gps.toString(),
          Colors.orange,
          Icons.gps_fixed_rounded,
        ),
        _buildChip(
          'GLONASS',
          glonass.toString(),
          Colors.red,
          Icons.star_rounded,
        ),
        _buildChip(
          'BeiDou',
          beidou.toString(),
          Colors.purple,
          Icons.stars_rounded,
        ),
      ],
    );
  }

  Widget _buildChip(
    String label,
    String value,
    MaterialColor color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color.shade100, color.shade200]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.shade200.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color.shade700),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              color: color.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color.shade900,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSatelliteRow(SatelliteInfo sat) {
    final signalStrength = sat.cn0DbHz;
    final signalColor = signalStrength > 35
        ? Colors.teal
        : signalStrength > 25
        ? Colors.orange
        : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: sat.usedInFix ? Colors.teal.shade300 : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: sat.usedInFix
                ? Colors.teal.shade100.withOpacity(0.5)
                : Colors.grey.shade200.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 0,
            child: Container(
              constraints: const BoxConstraints(minWidth: 60, maxWidth: 90),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getConstellationColor(sat.constellation).shade200,
                    _getConstellationColor(sat.constellation).shade400,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: _getConstellationColor(
                      sat.constellation,
                    ).withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                sat.constellation,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.tag_rounded,
                          size: 16,
                          color: Colors.indigo.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'ID: ${sat.svid}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: signalColor.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.signal_cellular_alt_rounded,
                            size: 16,
                            color: signalColor.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            sat.cn0DbHz.toStringAsFixed(1),
                            style: TextStyle(
                              color: signalColor.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            ' dB',
                            style: TextStyle(
                              color: signalColor.shade600,
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.height_rounded,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'El: ${sat.elevation.toStringAsFixed(1)}°',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.explore_rounded,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Az: ${sat.azimuth.toStringAsFixed(1)}°',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (sat.usedInFix)
            Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade400, Colors.teal.shade600],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  MaterialColor _getConstellationColor(String constellation) {
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
