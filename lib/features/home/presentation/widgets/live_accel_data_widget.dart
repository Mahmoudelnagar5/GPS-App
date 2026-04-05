import 'package:flutter/material.dart';
import '../../data/models/accelerometer_models.dart';

class LiveAccelDataWidget extends StatelessWidget {
  final AccelerometerData? data;

  const LiveAccelDataWidget({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.sensors, color: Colors.purple.shade700, size: 28),
                const SizedBox(width: 12),
                const Text(
                  'Live Accelerometer Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (data != null) ...[
              _buildAxisBar('X-Axis', data!.x, Colors.red),
              const SizedBox(height: 12),
              _buildAxisBar('Y-Axis', data!.y, Colors.green),
              const SizedBox(height: 12),
              _buildAxisBar('Z-Axis', data!.z, Colors.blue),
              const SizedBox(height: 16),
              _buildMagnitude(data!.magnitude),
            ] else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No data available',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAxisBar(String label, double value, Color color) {
    final absValue = value.abs();
    final clampedValue = absValue.clamp(0.0, 4.0);
    final percentage = clampedValue / 4.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            Text(
              '${value.toStringAsFixed(2)}g',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Stack(
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            FractionallySizedBox(
              widthFactor: percentage,
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMagnitude(double magnitude) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade50, Colors.purple.shade100],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.analytics, color: Colors.purple),
              SizedBox(width: 8),
              Text(
                'Magnitude',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          Text(
            '${magnitude.toStringAsFixed(2)}g',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.purple.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
