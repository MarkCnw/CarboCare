import 'package:flutter/material.dart';

class CarbonLevelCard extends StatelessWidget {
  final double totalCarbon;
  final double maxLimit;

  const CarbonLevelCard({
    super.key,
    required this.totalCarbon,
    this.maxLimit = 100.0, required double sickThreshold,
  });

  @override
  Widget build(BuildContext context) {
    // คำนวณเปอร์เซ็นต์ (0.0 ถึง 1.0)
    double progress = (totalCarbon / maxLimit).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20), // ระยะห่างซ้ายขวา
      padding: const EdgeInsets.all(20), // ระยะห่างภายในการ์ด
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // มุมมนโค้งๆ แบบในรูป
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // เงาจางๆ ดูแพง
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === ส่วนหัว: ชื่อหัวข้อ และ ป้ายคะแนน ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Carbon Level",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // ป้ายสีเขียวอ่อน (Badge)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50, // สีพื้นหลังเขียวอ่อนๆ
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${totalCarbon.toStringAsFixed(0)} / ${maxLimit.toStringAsFixed(0)} kg",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700, // ตัวหนังสือสีเขียวเข้ม
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // === ส่วนหลอด: Custom Progress Bar ===
          // ใช้ Stack เพื่อซ้อนหลอดสีเทากับหลอดสีเขียว
          SizedBox(
            height: 12, // ความหนาของหลอด
            child: Stack(
              children: [
                // 1. รางพื้นหลัง (สีเทา)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                // 2. หลอดสีเขียว (วิ่งตามค่า progress)
                FractionallySizedBox(
                  widthFactor: progress, // ความยาวตาม %
                  child: Container(
                    decoration: BoxDecoration(
                      // ไล่สีนิดนึงให้ดูมีมิติ (เขียวสว่าง -> เขียวเข้ม)
                      gradient: LinearGradient(
                        colors: [Colors.greenAccent.shade400, Colors.green.shade600],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // === ส่วนล่าง: ข้อความบอกระดับ ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Low Impact", // ตรงนี้เขียน Logic เปลี่ยนคำตามระดับได้นะ
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Limit",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}