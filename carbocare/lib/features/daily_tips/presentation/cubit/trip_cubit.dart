import 'package:bloc/bloc.dart';
import 'package:carbocare/core/services/api_service.dart';
import 'package:carbocare/core/services/isar_service.dart';
import 'package:carbocare/core/services/sound_service.dart';
import 'package:carbocare/features/daily_tips/data/models/trip_record_model.dart';

// --- States ---
abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<TripRecord> trips;
  final double totalDistance;
  final double totalCarbon;
  final String dailyTip;
  
  // ✨ เพิ่ม 2 ตัวแปรนี้
  final int goodActions; 
  final int badActions;

  TripLoaded(
    this.trips,
    this.totalDistance,
    this.totalCarbon, {
    this.dailyTip = "Loading tip...",
    // ✨ เพิ่มใน Constructor (กำหนดค่าเริ่มต้นเป็น 0)
    this.goodActions = 0,
    this.badActions = 0,
  });
}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}

// --- Cubit ---
class TripCubit extends Cubit<TripState> {
  final IsarService _isarService;
  final ApiService _apiService = ApiService();
  
  String _currentMessage = "มาช่วยโลกกันเถอะ! 🌍";

  TripCubit(this._isarService) : super(TripInitial());

  void loadTrips() async {
    // emit(TripLoading()); 
    await _updateData();
  }

  Future<void> _updateData() async {
    try {
      final trips = await _isarService.getAllTrips();

      double totalDist = 0;
      double totalCarb = 0;
      
      // ✨ ตัวแปรสำหรับนับจำนวนครั้ง
      int goodCount = 0;
      int badCount = 0;

      for (var trip in trips) {
        totalDist += trip.distance;
        totalCarb += trip.carbonKg;
        
        // ✨ Logic การนับ
        if (trip.carbonKg <= 0) {
          goodCount++; // ถ้าคาร์บอนติดลบหรือ 0 ถือว่าทำดี
        } else {
          badCount++; // ถ้าคาร์บอนเป็นบวก ถือว่าทำร้ายโลก
        }
      }

      // ✅ ส่งค่า goodCount, badCount ไปกับ State
      emit(TripLoaded(
        trips, 
        totalDist, 
        totalCarb, 
        dailyTip: _currentMessage,
        goodActions: goodCount,
        badActions: badCount,
      ));
    } catch (e) {
      emit(TripError("โหลดข้อมูลไม่สำเร็จ: $e"));
    }
  }

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
      
      try {
        String reaction = await _apiService.getReaction(isHealing);
        _currentMessage = reaction; 
      } catch (e) {
        print("⚠️ โหลดคำพูดไม่สำเร็จ ใช้คำเดิมต่อ: $e");
      }
      
      print("🔄 [FEED] กำลัง update ข้อมูล (Silent Refresh)...");
      await _updateData();
      
    } catch (e) {
      print("❌ [FEED ERROR] $e");
      emit(TripError("บันทึกไม่สำเร็จ: $e"));
    }
  }

  void deleteTrip(int id) async {
    try {
      await _isarService.deleteTrip(id);
      await _updateData();
    } catch (e) {
      emit(TripError("ลบไม่สำเร็จ: $e"));
    }
  }
}