import 'package:carbocare/features/daily_tips/data/models/trip_record_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    // 🔍 ปริ้นท์ที่อยู่ไฟล์ออกมาดูเลย ว่ามันไปสร้างที่ไหน
    print("📂 [ISAR PATH] Database อยู่ที่: ${dir.path}");

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [TripRecordSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }

  // แก้ไขฟังก์ชันบันทึก ให้เช็ค ID ที่ได้จาก Database จริงๆ
  Future<void> saveTripObject(TripRecord newTrip) async {
    final isar = await db;

    // ใช้ writeTxnSync เพื่อบังคับเขียนทันที (ตัดปัญหาเรื่อง await ค้าง)
    await isar.writeTxn(() async {
      final int id = await isar.tripRecords.put(newTrip);
      print(
        "🆔 [DB WRITE] Isar สร้าง ID ให้แล้ว คือ: $id",
      ); // <--- ถ้าเลขนี้ขึ้น แสดงว่าลง DB แน่นอน
    });
  }

  Future<List<TripRecord>> getAllTrips() async {
    final isar = await db;
    final results = await isar.tripRecords.where().findAll();
    print("📦 [DB READ] อ่านข้อมูลได้: ${results.length} รายการ");
    return results;
  }

  Future<void> deleteTrip(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.tripRecords.delete(id);
      print("🗑️ [DB DELETE] ลบรายการ ID: $id เรียบร้อย");
    });
  }
}
