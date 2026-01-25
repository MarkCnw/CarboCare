import 'package:flutter/material.dart';

class EarthSpeechBubble extends StatefulWidget {
  final String message;
  final bool isSick;

  const EarthSpeechBubble({
    super.key,
    required this.message,
    this.isSick = false,
  });

  @override
  State<EarthSpeechBubble> createState() => _EarthSpeechBubbleState();
}

class _EarthSpeechBubbleState extends State<EarthSpeechBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  String _currentMessage = "";

  @override
  void initState() {
    super.initState();
    _currentMessage = widget.message;

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(EarthSpeechBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message != widget.message) {
      // เมื่อข้อความเปลี่ยน ให้เล่น Animation
      _controller.reset();
      setState(() {
        _currentMessage = widget.message;
      });
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: CustomPaint(
                painter: _SpeechBubblePainter(
                  isSick: widget.isSick,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      // ไอคอนอิโมจิน้องโลก
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.isSick
                              ? Colors.orange.shade50
                              : Colors.green.shade50,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.isSick
                                ? Colors.orange.shade200
                                : Colors.green.shade200,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            widget.isSick ? "😷" : "😊",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ข้อความ
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isSick ? "น้องโลกพูด..." : "น้องโลกบอกว่า",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: widget.isSick
                                    ? Colors.orange.shade700
                                    : Colors.green.shade700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentMessage,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.4,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ไอคอนเสียง (optional)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: widget.isSick
                              ? Colors.orange.shade100
                              : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.volume_up_rounded,
                          size: 16,
                          color: widget.isSick
                              ? Colors.orange.shade700
                              : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom Painter สำหรับวาด Speech Bubble
class _SpeechBubblePainter extends CustomPainter {
  final bool isSick;

  _SpeechBubblePainter({required this.isSick});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final borderPaint = Paint()
      ..color = isSick ? Colors.orange.shade100 : Colors.green.shade100
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    const radius = 20.0;
    const tailWidth = 15.0;
    const tailHeight = 12.0;

    // วาดกล่องหลัก
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: const Radius.circular(radius),
    );
    path.lineTo(size.width, size.height - tailHeight - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.height - tailHeight),
      radius: const Radius.circular(radius),
    );

    // วาด Tail (หางชี้ลง)
    path.lineTo(tailWidth + 10, size.height - tailHeight);
    path.lineTo(5, size.height);
    path.lineTo(tailWidth, size.height - tailHeight);

    path.lineTo(radius, size.height - tailHeight);
    path.arcToPoint(
      Offset(0, size.height - tailHeight - radius),
      radius: const Radius.circular(radius),
    );
    path.lineTo(0, radius);
    path.arcToPoint(
      Offset(radius, 0),
      radius: const Radius.circular(radius),
    );

    path.close();

    // วาดเงา
    canvas.drawPath(path.shift(const Offset(0, 2)), shadowPaint);

    // วาดพื้นหลัง
    canvas.drawPath(path, paint);

    // วาดขอบ
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}