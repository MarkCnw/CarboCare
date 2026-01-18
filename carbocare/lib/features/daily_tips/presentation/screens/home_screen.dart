import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // จำเป็นสำหรับเช็คทิศทางการเลื่อน
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbocare/core/services/sound_service.dart';
import 'package:carbocare/core/widgets/earth_avatar_widget.dart';
import 'package:carbocare/features/daily_tips/presentation/cubit/trip_cubit.dart';
import 'package:carbocare/features/daily_tips/presentation/screens/trip_entry_screen.dart';
import 'package:carbocare/features/daily_tips/presentation/widgets/dashboard_card.dart';
import 'package:carbocare/features/daily_tips/presentation/widgets/trip_history_list.dart';
import 'package:carbocare/core/widgets/carbon_status_widget.dart';

// 1. เปลี่ยนเป็น StatefulWidget เพื่อจัดการ ScrollController
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ตัวควบคุมการเลื่อน
  late ScrollController _scrollController;
  // ตัวแปรเช็คว่าปุ่มควรแสดงไหม (เริ่มต้นโชว์)
  bool _isButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // ดักฟังการเลื่อน
    _scrollController.addListener(() {
      // ถ้าเลื่อนลง (Reverse) -> ซ่อนปุ่ม
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isButtonVisible) {
          setState(() {
            _isButtonVisible = false;
          });
        }
      }
      // ถ้าเลื่อนขึ้น (Forward) -> โชว์ปุ่ม
      else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isButtonVisible) {
          setState(() {
            _isButtonVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ใช้ Stack เพื่อซ้อนปุ่มไว้บนเนื้อหา
      body: SafeArea(
        child: Stack(
          children: [
            // === Layer 1: เนื้อหา (อยู่ด้านหลัง) ===
            BlocBuilder<TripCubit, TripState>(
              builder: (context, state) {
                if (state is TripLoaded) {
                  return SingleChildScrollView(
                    controller: _scrollController, // ผูก Controller ตรงนี้
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        // Tip Card
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Colors.green.shade200,
                            ),
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
                                  state.dailyTip,
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        EarthAvatarWidget(
                          totalCarbon: state.totalCarbon,
                          sickThreshold: 50.0,
                        ),

                        const SizedBox(height: 30),
                        CarbonLevelCard(
                          totalCarbon: state.totalCarbon,
                          maxLimit: 100.0,
                          sickThreshold: 100,
                        ),
                        const SizedBox(height: 30),

                        DashboardCard(
                          totalDist: state.totalDistance,
                          totalCarbon: state.totalCarbon,
                        ),

                        const SizedBox(height: 30),

                        // รายการประวัติ
                        const TripHistoryList(),

                        // ⚠️ สำคัญ: เว้นที่ว่างด้านล่างเผื่อไว้
                        // ไม่งั้นเนื้อหาล่างสุดจะโดนปุ่มบังเวลาปุ่มโชว์
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),

            // === Layer 2: ปุ่มลอย (Animated Positioned) ===
            AnimatedPositioned(
              duration: const Duration(
                milliseconds: 300,
              ), // ความเร็วอนิเมชั่น
              curve: Curves.easeInOut, // รูปแบบการเคลื่อนที่ให้นุ่มนวล
              bottom: _isButtonVisible
                  ? 20
                  : -100, // ถ้าโชว์อยู่สูง 20, ถ้าซ่อนให้ลงไปใต้จอ (-100)
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      SoundService.playStart();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TripEntryScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: const Text(
                      'ออกเดินทาง',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
