import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final double totalDist;
  final double totalCarbon;

  const DashboardCard({
    super.key, 
    required this.totalDist, 
    required this.totalCarbon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.directions_car, '${totalDist.toStringAsFixed(1)} km', 'ระยะทางรวม'),
          Container(height: 40, width: 1, color: Colors.grey.shade300),
          _buildStatItem(Icons.cloud, '${totalCarbon.toStringAsFixed(2)} kg', 'คาร์บอนสะสม'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 30),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}