import 'package:carbocare/features/daily_tips/data/models/feed_item.dart';
import 'package:flutter/material.dart';

// ✅ import FeedItem จาก earth_avatar_widget
// (ถ้า error ให้ย้าย FeedItem ไปไฟล์แยกหรือเขียนซ้ำตรงนี้)



class FeedMenuItem {
  final String type;
  final IconData icon;
  final Color color;
  final String label;
  final bool isHealing;
  final double carbonImpact;

  FeedMenuItem({
    required this.type,
    required this.icon,
    required this.color,
    required this.label,
    required this.isHealing,
    required this.carbonImpact,
  });
}

class FeedMenuWidget extends StatelessWidget {
  const FeedMenuWidget({super.key});

  List<FeedMenuItem> get _menuItems => [
        FeedMenuItem(
          type: 'tree',
          icon: Icons.park,
          color: Colors.green,
          label: 'ต้นไม้',
          isHealing: true,
          carbonImpact: -5.0,
        ),
        FeedMenuItem(
          type: 'water',
          icon: Icons.water_drop,
          color: Colors.blue,
          label: 'น้ำ',
          isHealing: true,
          carbonImpact: -2.0,
        ),
        FeedMenuItem(
          type: 'motorcycle',
          icon: Icons.two_wheeler,
          color: Colors.orange,
          label: 'มอไซค์',
          isHealing: false,
          carbonImpact: 3.0,
        ),
        FeedMenuItem(
          type: 'car',
          icon: Icons.directions_car,
          color: Colors.red,
          label: 'รถยนต์',
          isHealing: false,
          carbonImpact: 8.0,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "ลากไอคอนไปที่โลกเพื่อให้อาหาร 🌍",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _menuItems.map((item) {
              final feedData = FeedItem(
                type: item.type,
                carbonImpact: item.carbonImpact,
                isHealing: item.isHealing,
              );
              
              print("🎨 [MENU] สร้างไอเท็ม: ${feedData.toString()}");
              
              return Draggable<FeedItem>(
                data: feedData,
                feedback: _buildFloatingIcon(item, isDragging: true),
                childWhenDragging: _buildIcon(item, opacity: 0.3),
                child: _buildIcon(item),
                onDragStarted: () {
                  print("🚀 [DRAG START] เริ่มลาก: ${item.type}");
                },
                onDragEnd: (details) {
                  print("🏁 [DRAG END] ปล่อย: ${item.type} | wasAccepted: ${details.wasAccepted}");
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(FeedMenuItem item, {double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: item.color, width: 2),
            ),
            child: Icon(item.icon, color: item.color, size: 30),
          ),
          const SizedBox(height: 5),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingIcon(FeedMenuItem item, {bool isDragging = false}) {
    return Material(
      color: Colors.transparent,
      child: Transform.scale(
        scale: isDragging ? 1.2 : 1.0,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: item.color.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: item.color.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(item.icon, color: Colors.white, size: 35),
        ),
      ),
    );
  }
}