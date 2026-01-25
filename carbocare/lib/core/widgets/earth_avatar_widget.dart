import 'package:carbocare/features/daily_tips/data/models/feed_item.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



class EarthAvatarWidget extends StatefulWidget {
  final double totalCarbon;
  final double sickThreshold;
  final Function(String itemType, double impact, bool isHealing)?
  onItemReceived;

  const EarthAvatarWidget({
    super.key,
    required this.totalCarbon,
    this.sickThreshold = 50.0,
    this.onItemReceived,
  });

  @override
  State<EarthAvatarWidget> createState() => _EarthAvatarWidgetState();
}

class _EarthAvatarWidgetState extends State<EarthAvatarWidget>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSick = widget.totalCarbon >= widget.sickThreshold;

    // ✅ ใช้ LayoutBuilder เพื่อให้ได้ขนาดจริง
    return LayoutBuilder(
      builder: (context, constraints) {
        return DragTarget<FeedItem>(
          onWillAcceptWithDetails: (details) {
            print("👀 [DRAG] กำลังลากเข้ามา: ${details.data.type}");
            setState(() => _isHovering = true);
            _scaleController.forward();
            return true;
          },
          onLeave: (data) {
            print("🚫 [DRAG] ลากออกไป");
            setState(() => _isHovering = false);
            _scaleController.reverse();
          },
          onAcceptWithDetails: (details) {
            print("✅ [DRAG] วางแล้ว! ${details.data.type}");
            setState(() => _isHovering = false);
            _scaleController.reverse();

            if (widget.onItemReceived != null) {
              final item = details.data;
              print(
                "📞 [DRAG] เรียก callback: type=${item.type}, impact=${item.carbonImpact}",
              );
              widget.onItemReceived!(
                item.type,
                item.carbonImpact,
                item.isHealing,
              );
            } else {
              print("⚠️ [DRAG] WARNING: onItemReceived เป็น null!");
            }
          },
          builder: (context, candidateData, rejectedData) {
            return AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    // ✅ ใช้ width จาก constraints
                    width: constraints.maxWidth,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: _isHovering
                          ? Colors.green.withOpacity(0.2)
                          : Colors.transparent,
                      border: _isHovering
                          ? Border.all(color: Colors.green, width: 3)
                          : null,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Lottie.asset(
                            isSick
                                ? 'assets/earth/sick.json'
                                : 'assets/earth/happy.json',
                            fit: BoxFit.contain,
                            repeat: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          isSick
                              ? "โลกเริ่มป่วยแล้ว ช่วยโลกด้วยย!!"
                              : "โลกแข็งแรง 💚",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSick
                                ? const Color.fromARGB(255, 255, 255, 255)
                                : Colors.green[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
