import 'package:flutter/material.dart';

class EarthFactWidget extends StatelessWidget {
  final String title;
  final String fact;

  const EarthFactWidget({
    super.key,
    required this.title,
    required this.fact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. รูปน้องโลกใส่แว่น (ผู้เล่าเรื่อง)
          Container(
            margin: const EdgeInsets.only(top: 5),
            child: Image.asset(
              'assets/images/earth_happy.png', // ⚠️ ใช้รูป earth_smart หรือ earth_happy ก็ได้
              width: 60,
              height: 60,
            ),
          ),
          const SizedBox(width: 10),

          // 2. กล่องคำพูด (Speech Bubble)
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.green.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title, // เช่น "รู้หรือไม่?"
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    fact, // เนื้อหาความรู้
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
