// lib/features/daily_tips/presentation/widgets/earth_avatar_widget.dart

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EarthAvatarWidget extends StatelessWidget {
  final double totalCarbon;
  final double sickThreshold;

  const EarthAvatarWidget({
    super.key,
    required this.totalCarbon,
    this.sickThreshold = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    // เช็คสถานะว่าป่วยหรือยัง
    bool isSick = totalCarbon >= sickThreshold;

    return Column(
      children: [
        // 1. ส่วนอนิเมชั่น Lottie
        SizedBox(
          height: 200, 
          child: Lottie.asset(
            isSick
                ? 'assets/earth/sick.json'   // ไฟล์ตอนป่วย
                : 'assets/earth/happy.json', // ไฟล์ตอนยิ้ม
            fit: BoxFit.contain,
            repeat: true,
          ),
        ),

        const SizedBox(height: 15), // เว้นระยะห่างนิดนึง

        // 2. ส่วนข้อความใต้รูป (เพิ่มตรงนี้)
        Text(
          isSick 
              ? "โลกเริ่มป่วยแล้ว! ลดด่วน 😷" 
              : "โลกกำลังยิ้ม! ขอบคุณนะ 💚",
          style: TextStyle(
            fontSize: 18, // ปรับขนาดตัวหนังสือ
            fontWeight: FontWeight.bold, // ตัวหนา
            color: isSick ? Colors.redAccent : Colors.green[700], // เปลี่ยนสีตามอารมณ์
          ),
          textAlign: TextAlign.center, // จัดกึ่งกลาง
        ),
      ],
    );
  }
}