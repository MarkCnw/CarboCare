import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbocare/features/daily_tips/presentation/cubit/trip_cubit.dart';

class TripHistoryList extends StatelessWidget {
  const TripHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TripCubit, TripState>(
      builder: (context, state) {
        if (state is TripLoaded) {
          // --- 1. กรณีไม่มีข้อมูล (Empty State) ---
          if (state.trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.history_edu, size: 50, color: Colors.green.shade300),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'ยังไม่มีการเดินทาง',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  Text(
                    'เริ่มบันทึกเพื่อดูสถิติของคุณกันเถอะ!',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          // --- 2. ส่วนหัวข้อ + รายการ (List) ---
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // หัวข้อ (Header)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ประวัติล่าสุด 🕒",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Text(
                      "${state.trips.length} รายการ",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // รายการ (List Items)
              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                shrinkWrap: true, // สำคัญ! เพื่อให้แทรกใน Column ได้
                physics: const NeverScrollableScrollPhysics(), // ปิด scroll ของตัวเอง
                itemCount: state.trips.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  // กลับลำดับให้โชว์อันล่าสุดก่อน (Latest First)
                  final trip = state.trips[state.trips.length - 1 - index];
                  
                  // เช็คว่าเป็นฮีโร่ช่วยโลกไหม (คาร์บอนติดลบ หรือ 0)
                  final isHero = trip.carbonKg <= 0;
                  final vehicleType = trip.vehicleType ?? 'Car';

                  return Dismissible(
                    key: Key(trip.id.toString()),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                       return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: const Text("ลบรายการ?"),
                            content: const Text("คุณต้องการลบประวัติการเดินทางนี้ใช่ไหม?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text("ยกเลิก", style: TextStyle(color: Colors.grey)),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text("ลบ"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 25),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("ลบ", style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          Icon(Icons.delete_forever_rounded, color: Colors.red.shade700, size: 28),
                        ],
                      ),
                    ),
                    onDismissed: (_) {
                      context.read<TripCubit>().deleteTrip(trip.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // === 1. ไอคอนยานพาหนะ ===
                          Container(
                            width: 55,
                            height: 55,
                            decoration: BoxDecoration(
                              color: _getVehicleColor(vehicleType).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              _getVehicleIcon(vehicleType),
                              color: _getVehicleColor(vehicleType),
                              size: 28,
                            ),
                          ),
                          
                          const SizedBox(width: 15),

                          // === 2. รายละเอียดตรงกลาง ===
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${trip.distance.toStringAsFixed(1)} km",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // ป้ายบอกประเภทยานพาหนะเล็กๆ
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        vehicleType,
                                        style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded, size: 12, color: Colors.grey.shade400),
                                    const SizedBox(width: 4),
                                    Text(
                                      _formatDate(trip.date), // ฟังก์ชันจัดรูปแบบวันที่
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // === 3. ปริมาณคาร์บอน (ขวาสุด) ===
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: isHero ? Colors.green.shade50 : Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isHero ? Colors.green.shade100 : Colors.orange.shade100,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isHero ? Icons.eco : Icons.cloud, 
                                      size: 14, 
                                      color: isHero ? Colors.green.shade700 : Colors.orange.shade700
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      isHero 
                                        ? trip.carbonKg.abs().toStringAsFixed(1)
                                        : "+${trip.carbonKg.toStringAsFixed(1)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: isHero ? Colors.green.shade700 : Colors.orange.shade800,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isHero ? "ช่วยโลก 🌏" : "kg CO₂",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isHero ? Colors.green.shade400 : Colors.orange.shade300,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  // --- Helper Functions ---

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0 && now.day == date.day) {
      return "วันนี้, ${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}";
    } else if (diff.inDays == 0 || (diff.inDays == 1 && now.day != date.day)) {
      return "เมื่อวาน, ${date.hour.toString().padLeft(2,'0')}:${date.minute.toString().padLeft(2,'0')}";
    }
    return "${date.day}/${date.month}/${date.year}";
  }

  IconData _getVehicleIcon(String type) {
    switch (type) {
      case 'Car': return Icons.directions_car_filled_rounded;
      case 'Motorcycle': return Icons.two_wheeler_rounded;
      case 'Bicycle': return Icons.directions_bike_rounded;
      case 'Walk': return Icons.directions_walk_rounded;
      default: return Icons.commute_rounded;
    }
  }

  Color _getVehicleColor(String type) {
    switch (type) {
      case 'Car': return Colors.blueAccent;
      case 'Motorcycle': return Colors.purpleAccent;
      case 'Bicycle': return Colors.teal;
      case 'Walk': return Colors.green;
      default: return Colors.blueGrey;
    }
  }
}