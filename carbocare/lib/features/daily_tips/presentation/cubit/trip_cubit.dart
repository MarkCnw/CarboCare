import 'package:bloc/bloc.dart';
import 'package:carbocare/core/services/api_service.dart';
import 'package:carbocare/core/services/isar_service.dart';
import 'package:carbocare/core/services/sound_service.dart';
import 'package:carbocare/features/daily_tips/data/models/trip_record_model.dart';

// --- States (ส่วนนี้เหมือนเดิม ไม่ต้องแก้) ---
abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<TripRecord> trips;
  final double totalDistance;
  final double totalCarbon;
  final String dailyTip;

  TripLoaded(
    this.trips,
    this.totalDistance,
    this.totalCarbon, {
    this.dailyTip = "Loading tip...",
  });
}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}

// --- Cubit (แก้เฉพาะส่วนนี้) ---
class TripCubit extends Cubit<TripState> {
  final IsarService _isarService;
  final ApiService _apiService = ApiService();
  
  // ✨ เพิ่ม: ตัวแปรเก็บข้อความปัจจุบัน (เริ่มต้นเป็นค่า Default)
  String _currentMessage = "มาช่วยโลกกันเถอะ! 🌍";

  TripCubit(this._isarService) : super(TripInitial());

  // แก้ไข: ไม่เรียก getDailyTip แล้ว ให้ใช้ _updateData แทน
  void loadTrips() async {
    // emit(TripLoading()); // (Optional) ถ้าอยากให้หมุนตอนเข้าแอปครั้งแรก ให้เอา comment ออก
    await _updateData();
  }

  // ✨ เพิ่ม: ฟังก์ชันอัปเดตข้อมูลแบบเงียบ (Silent Update)
  // ช่วยให้หน้าจอเปลี่ยนตัวเลขได้เลยโดยไม่กระพริบ
  Future<void> _updateData() async {
    try {
      final trips = await _isarService.getAllTrips();

      double totalDist = 0;
      double totalCarb = 0;

      for (var trip in trips) {
        totalDist += trip.distance;
        totalCarb += trip.carbonKg;
      }

      // ✅ ส่ง _currentMessage ที่มีอยู่ไปแสดงเลย
      emit(TripLoaded(trips, totalDist, totalCarb, dailyTip: _currentMessage));
    } catch (e) {
      emit(TripError("โหลดข้อมูลไม่สำเร็จ: $e"));
    }
  }

  // 🔥 แก้ไข: ฟังก์ชันให้อาหาร/ของแก่โลก
  void feedEarth(String itemType, double carbonImpact, bool isHealing) async {
    print("🎯 [FEED] เริ่มให้: $itemType | คาร์บอน: $carbonImpact | Healing: $isHealing");
    
    try {
      final newRecord = TripRecord()
        ..distance = 1.0 
        ..carbonKg = carbonImpact 
        ..date = DateTime.now()
        ..itemType = itemType; 

      await _isarService.saveTripObject(newRecord);
      
      print("✅ [FEED] บันทึกสำเร็จ! กำลังเล่นเสียง...");
      SoundService.playEffect(isHealing: isHealing);
      
      // ✨ เพิ่ม: ไปดึงคำพูดกวนๆ จาก API มาอัปเดต!
      try {
        String reaction = await _apiService.getReaction(isHealing);
        _currentMessage = reaction; // เปลี่ยนข้อความที่จะโชว์
      } catch (e) {
        print("⚠️ โหลดคำพูดไม่สำเร็จ ใช้คำเดิมต่อ: $e");
      }
      
      print("🔄 [FEED] กำลัง update ข้อมูล (Silent Refresh)...");
      // ✅ เรียก _updateData แทน loadTrips เพื่อไม่ให้จอโหลดหมุนๆ
      await _updateData();
      
    } catch (e) {
      print("❌ [FEED ERROR] $e");
      emit(TripError("บันทึกไม่สำเร็จ: $e"));
    }
  }

  void deleteTrip(int id) async {
    try {
      await _isarService.deleteTrip(id);
      // ✅ ใช้ _updateData แทน loadTrips
      await _updateData();
    } catch (e) {
      emit(TripError("ลบไม่สำเร็จ: $e"));
    }
  }
}