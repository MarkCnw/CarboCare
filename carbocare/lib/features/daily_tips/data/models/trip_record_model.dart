import 'package:isar/isar.dart';

part 'trip_record_model.g.dart';

@collection
class TripRecord {
  Id id = Isar.autoIncrement; // ให้ Isar สร้าง ID ให้เอง

  late double distance; // ระยะทาง (กิโลเมตร)
  late double carbonKg;

  @Index()
  late DateTime date; // วันที่บันทึก

  String?
  vehicleType; // ประเภทรถ (ใส่ไว้ก่อนตาม Domain แต่ Sprint นี้อาจ hardcode ไปก่อน)
}
