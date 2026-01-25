import 'package:isar/isar.dart';

part 'trip_record_model.g.dart';

@collection
class TripRecord {
  Id id = Isar.autoIncrement;

  late double distance; // ใช้เก็บ "จำนวน" (เช่น ต้นไม้ 1 ต้น, น้ำ 1 แก้ว)
  late double carbonKg; // ผลกระทบต่อคาร์บอน (+/-)

  @Index()
  late DateTime date;

  // 🔥 เปลี่ยนจาก vehicleType เป็น itemType
  String? itemType; // ประเภท: "tree", "water", "motorcycle", "car"
}