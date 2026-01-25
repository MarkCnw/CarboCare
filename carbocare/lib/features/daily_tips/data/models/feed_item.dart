// 📂 ไฟล์: lib/features/daily_tips/data/models/feed_item.dart

class FeedItem {
  final String type;
  final double carbonImpact;
  final bool isHealing;

  FeedItem({
    required this.type,
    required this.carbonImpact,
    required this.isHealing,
  });
  
  @override
  String toString() => 'FeedItem(type: $type, impact: $carbonImpact)';
}