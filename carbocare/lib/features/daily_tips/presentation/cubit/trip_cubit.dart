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
  final String dailyTip; // <--- เพิ่มตรงนี้

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

// --- Cubit ---
class TripCubit extends Cubit<TripState> {
  final IsarService _isarService;
  final ApiService _apiService = ApiService(); // สร้างตัวยิง API

  TripCubit(this._isarService) : super(TripInitial());

  void loadTrips() async {
    emit(TripLoading());
    try {
      final trips = await _isarService.getAllTrips();

      // --- Logic คำนวณผลรวม ---
      double totalDist = 0;
      double totalCarb = 0;

      for (var trip in trips) {
        totalDist += trip.distance;
        totalCarb += trip.carbonKg;
      }
      // -----------------------

      final tip = await _apiService.getDailyTip();

      // ส่งทั้ง List และ ผลรวม ไปให้ UI
      emit(TripLoaded(trips, totalDist, totalCarb, dailyTip: tip));
    } catch (e) {
      emit(TripError("โหลดข้อมูลไม่สำเร็จ: $e"));
    }
  }

  void addTrip(double distance, String vehicleType) async {
    try {
      double emissionFactor = 0.0;
      bool isHealing = false;

      // ---------------------------------------------------
      // 🟢 LOGIC ใหม่: รถ = ทำลาย (+), เดิน/ปั่น = รักษา (-)
      // ---------------------------------------------------
      if (vehicleType == 'Car') {
        emissionFactor = 0.12; // เพิ่มคาร์บอน (ทำลาย)
        isHealing = false;
      } else if (vehicleType == 'Motorcycle') {
        emissionFactor = 0.05; // เพิ่มน้อยหน่อย
        isHealing = false;
      } else if (vehicleType == 'Bicycle') {
        emissionFactor = -0.05; // ลดคาร์บอน (รักษา)
        isHealing = true;
      } else if (vehicleType == 'Walk') {
        emissionFactor = -0.10; // ลดเยอะ (รักษามาก)
        isHealing = true;
      }

      final double carbonResult = distance * emissionFactor;

      final newTrip = TripRecord()
        ..distance = distance
        ..carbonKg =
            carbonResult // ค่านี้จะเป็นลบ ถ้าเดินหรือปั่น
        ..date = DateTime.now()
        ..vehicleType = vehicleType;

      await _isarService.saveTripObject(newTrip);
      SoundService.playEffect(isHealing: isHealing);
      loadTrips();
    } catch (e) {
      emit(TripError("บันทึกไม่สำเร็จ: $e"));
    }
  }

  // เพิ่มต่อท้ายใน class TripCubit
  void deleteTrip(int id) async {
    try {
      await _isarService.deleteTrip(id);
      loadTrips(); // ลบเสร็จโหลดใหม่ทันที เพื่อให้รายการหายไปจากหน้าจอ
    } catch (e) {
      emit(TripError("ลบไม่สำเร็จ: $e"));
    }
  }
}
