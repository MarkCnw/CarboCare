import 'package:carbocare/features/daily_tips/presentation/cubit/trip_cubit.dart';
// อย่าลืม import ไฟล์ widget ที่เพิ่งสร้าง
import 'package:carbocare/features/daily_tips/presentation/widgets/trip_history_list.dart';
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
          // --- ส่วนกรอกข้อมูล (เหมือนเดิม) ---
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'บันทึกข้อมูล',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
