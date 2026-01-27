import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  // ✨ เปลี่ยนตัวแปรรับค่า เป็นจำนวนครั้ง
  final int goodCount;
  final int badCount;

  const DashboardCard({
    super.key,
    required this.goodCount,
    required this.badCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // === การ์ดซ้าย: ช่วยโลก (สีเขียว) ===
          Expanded(
            child: _buildStatCard(
              icon: Icons.volunteer_activism, // ไอคอนรูปหัวใจ/มือ
              iconColor: Colors.green,
              bgColor: Colors.green.shade50,
              value: "$goodCount ครั้ง", // แสดงจำนวนครั้ง
              label: "ช่วยโลก 🌿",
              arrowIcon: Icons.thumb_up_alt_rounded,
            ),
          ),

          const SizedBox(width: 15),

          // === การ์ดขวา: ทำร้ายโลก (สีส้มแดง) ===
          Expanded(
            child: _buildStatCard(
              icon: Icons.whatshot, // ไอคอนไฟ
              iconColor: Colors.deepOrange,
              bgColor: Colors.orange.shade50,
              value: "$badCount ครั้ง", // แสดงจำนวนครั้ง
              label: "ทำร้ายโลก 🔥",
              arrowIcon: Icons.warning_rounded,
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้าง UI (เหมือนเดิม ไม่ต้องแก้ logic ข้างใน)
  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String value,
    required String label,
    required IconData arrowIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Icon(arrowIcon, color: Colors.grey.shade300, size: 18),
            ],
          ),
          
          const SizedBox(height: 20),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 5),

          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}