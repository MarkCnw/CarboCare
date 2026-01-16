// lib/features/daily_tips/presentation/widgets/carbon_status_widget.dart

import 'package:flutter/material.dart';

class CarbonStatusWidget extends StatelessWidget {
  final double totalCarbon;
  final double maxLimit; // ขีดจำกัดสูงสุด (เช่น 100)
  final double sickThreshold;

  const CarbonStatusWidget({
    super.key,
    required this.totalCarbon,
    this.maxLimit = 100.0,
    this.sickThreshold = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    bool isSick = totalCarbon >= sickThreshold;

    // คำนวณเปอร์เซ็นต์หลอด (ไม่ให้เกิน 1.0)
    double progress = (totalCarbon / maxLimit).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // แถบ Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 15,
              backgroundColor: Colors.grey[200],
              // ถ้าป่วยหลอดสีส้ม ถ้าดีหลอดสีฟ้า/เขียว
              valueColor: AlwaysStoppedAnimation<Color>(
                isSick ? Colors.orange : Colors.blueAccent,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ตัวเลข (เช่น 45 / 100 kg)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "ระดับคาร์บอนสะสม",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                "${totalCarbon.toStringAsFixed(1)} / ${maxLimit.toStringAsFixed(0)} kg",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
