import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final double totalDist;
  final double totalCarbon;

  const DashboardCard({
    super.key,
    required this.totalDist,
    required this.totalCarbon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // === กล่องซ้าย: ระยะทาง (สีฟ้า) ===
          Expanded(
            child: _buildStatCard(
              icon: Icons.directions_walk, // หรือ directions_car
              iconColor: Colors.blueAccent,
              bgColor: Colors.blue.shade50,
              value: "${totalDist.toStringAsFixed(1)} km",
              label: "ระยะทางรวม",
              arrowIcon: Icons.arrow_outward, // ลูกศรชี้ขึ้นขวา
            ),
          ),

          const SizedBox(width: 15), // เว้นระยะห่างตรงกลาง

          // === กล่องขวา: คาร์บอน (สีเขียว) ===
          Expanded(
            child: _buildStatCard(
              icon: Icons.co2,
              
              iconColor: Colors.green,
              bgColor: Colors.green.shade50,
              value: "${totalCarbon.toStringAsFixed(1)} kg",
              label: "คาร์บอนสะสม",
              arrowIcon: Icons.arrow_downward, // ลูกศรชี้ลง (สื่อว่าลด)
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันสร้างการ์ดแต่ละใบ
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
        borderRadius: BorderRadius.circular(25), // มุมโค้งมนตามรูป
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // เงาจางๆ
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // แถวบน: ไอคอนวงกลม และ ลูกศรเล็ก
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ไอคอนในวงกลม
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor, // สีพื้นหลังไอคอน (จางๆ)
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              // ลูกศรเล็กๆ มุมขวาบน
              Icon(arrowIcon, color: Colors.grey.shade300, size: 18),
            ],
          ),
          
          const SizedBox(height: 20), // ระยะห่าง

          // ตัวเลขค่า (ตัวใหญ่หนา)
          Text(
            value,
            style: const TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          
          const SizedBox(height: 5),

          // ป้ายชื่อ (ตัวเล็กสีเทา)
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