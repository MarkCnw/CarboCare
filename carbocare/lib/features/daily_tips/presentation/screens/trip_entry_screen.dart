import 'package:carbocare/features/daily_tips/presentation/cubit/trip_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TripEntryScreen extends StatefulWidget {
  const TripEntryScreen({super.key});

  @override
  State<TripEntryScreen> createState() => _TripEntryScreenState();
}

class _TripEntryScreenState extends State<TripEntryScreen> {
  final TextEditingController _distanceController =
      TextEditingController();
  String _selectedVehicle = 'Car';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('บันทึกใหม่'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          // --- ส่วนกรอกข้อมูล ---
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _distanceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ระยะทาง (km)',
                    prefixIcon: Icon(Icons.edit_road),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _selectedVehicle,
                  decoration: const InputDecoration(
                    labelText: 'พาหนะ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.commute),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Car',
                      child: Text('รถยนต์ 🚗'),
                    ),
                    DropdownMenuItem(
                      value: 'Motorcycle',
                      child: Text('มอไซค์ 🛵'),
                    ),
                    DropdownMenuItem(
                      value: 'Bicycle',
                      child: Text('จักรยาน 🚲'),
                    ),
                    DropdownMenuItem(
                      value: 'Walk',
                      child: Text('เดินเท้า 🏃'),
                    ),
                  ],
                  onChanged: (value) =>
                      setState(() => _selectedVehicle = value!),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final distance = double.tryParse(
                        _distanceController.text,
                      );
                      if (distance != null) {
                        context.read<TripCubit>().addTrip(
                          distance,
                          _selectedVehicle,
                        );
                        Navigator.pop(
                          context,
                        ); // บันทึกเสร็จแล้วปิดหน้านี้ กลับไปหน้าโลก
                      }
                    },
                    child: const Text('บันทึกข้อมูล'),
                  ),
                ),
              ],
            ),
          ),

          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "ประวัติล่าสุด",
              style: TextStyle(color: Colors.grey),
            ),
          ),

          // --- รายการ List ---
          Expanded(
            child: BlocBuilder<TripCubit, TripState>(
              builder: (context, state) {
                if (state is TripLoaded) {
                  return ListView.builder(
                    itemCount: state.trips.length,
                    // ใน ListView.builder
                    itemBuilder: (context, index) {
                      final trip = state.trips[index];

                      // เช็คว่ารายการนี้ "เพิ่ม" หรือ "ลด" คาร์บอน
                      // ถ้าค่าน้อยกว่า 0 แปลว่าเป็น Hero (ลดคาร์บอน)
                      final isHealing = trip.carbonKg < 0;

                      return Dismissible(
                        key: Key(trip.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) =>
                            context.read<TripCubit>().deleteTrip(trip.id),
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          // ถ้าเป็น Hero ให้พื้นหลังการ์ดสีเขียวอ่อนๆ
                          color: isHealing
                              ? Colors.green.shade50
                              : Colors.white,
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isHealing
                                    ? Colors.green.shade100
                                    : Colors.orange.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                // เปลี่ยนไอคอน: ลด = หัวใจ, เพิ่ม = เมฆ
                                isHealing
                                    ? Icons.volunteer_activism
                                    : Icons.cloud,
                                color: isHealing
                                    ? Colors.green
                                    : Colors.deepOrange,
                              ),
                            ),
                            title: Text(
                              '${trip.distance} km (${trip.vehicleType})',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: isHealing
                                ? Text(
                                    'ช่วยลดคาร์บอน: ${trip.carbonKg.abs().toStringAsFixed(2)} kg 💚', // ใช้ .abs() ตัดเครื่องหมายลบออกตอนโชว์
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    'ปล่อยคาร์บอน: +${trip.carbonKg.toStringAsFixed(2)} kg',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                            trailing: Text(
                              trip.date.toString().substring(0, 10),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
