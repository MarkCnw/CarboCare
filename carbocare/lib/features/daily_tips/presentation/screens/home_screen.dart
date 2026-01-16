import 'package:carbocare/core/services/sound_service.dart';
import 'package:carbocare/core/widgets/earth_avatar_widget.dart';
import 'package:carbocare/features/daily_tips/presentation/cubit/trip_cubit.dart';
import 'package:carbocare/features/daily_tips/presentation/screens/trip_entry_screen.dart';
import 'package:carbocare/features/daily_tips/presentation/widgets/dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbocare/core/widgets/carbon_status_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CarBoCare")),
      body: SafeArea(
        child: BlocBuilder<TripCubit, TripState>(
          builder: (context, state) {
            if (state is TripLoaded) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // 1. วางรูปน้องโลก (Widget ใหม่)
                    EarthAvatarWidget(
                      totalCarbon: state.totalCarbon,
                      sickThreshold: 50.0, // ส่งค่าเกณฑ์ป่วย
                    ),

                    const SizedBox(height: 30),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lightbulb,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              state.dailyTip, // <--- ข้อความจาก API
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                     const SizedBox(height: 30),
                    CarbonStatusWidget(
                      totalCarbon: state.totalCarbon,
                      maxLimit: 100.0, // ส่งค่าเต็มหลอด
                      sickThreshold: 50.0, // ส่งค่าเกณฑ์ป่วย
                    ),
                    // 2. Dashboard สรุปผล
                    DashboardCard(
                      totalDist: state.totalDistance,
                      totalCarbon: state.totalCarbon,
                    ),

                    const SizedBox(height: 40),

                    // 3. ปุ่ม Action "ออกเดินทาง"
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            SoundService.playStart();
                            // กดแล้วไปหน้ากรอกข้อมูล (TripEntryScreen)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TripEntryScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add_location_alt_outlined,
                          ),
                          label: const Text(
                            'ออกเดินทาง',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
