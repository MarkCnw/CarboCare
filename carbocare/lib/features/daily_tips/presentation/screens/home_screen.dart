import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbocare/core/services/sound_service.dart';
import 'package:carbocare/core/widgets/earth_avatar_widget.dart';
import 'package:carbocare/features/daily_tips/presentation/cubit/trip_cubit.dart';
import 'package:carbocare/features/daily_tips/presentation/screens/trip_entry_screen.dart';
import 'package:carbocare/features/daily_tips/presentation/widgets/dashboard_card.dart';
import 'package:carbocare/features/daily_tips/presentation/widgets/trip_history_list.dart';
import 'package:carbocare/core/widgets/carbon_status_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  bool _isButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isButtonVisible) {
          setState(() {
            _isButtonVisible = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
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
      body: SafeArea(
        child: BlocBuilder<TripCubit, TripState>(
          builder: (context, state) {
            if (state is TripLoaded) {
              final isSick = state.totalCarbon >= 50.0;
              SoundService.playAmbience(isSick: isSick);

              // -------------------------------------------

              return Stack(
                children: [
                  // Background Layer with Gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isSick
                            ? [
                                const Color(0xFF4A4A4A), // เทาคาร์บอนเข้ม
                                const Color(0xFF7A7A7A), // เทากลาง
                                const Color(0xFFB0B0B0), // เทาอ่อน
                              ]
                            : [
                                const Color(0xFFA5D6A7), // เขียวอ่อนสดใส
                                const Color(0xFFC8E6C9), // เขียวพาสเทล
                                const Color(0xFFE8F5E9), // เขียวอ่อนมาก
                              ],
                      ),
                    ),
                  ),

                  // Content Layer
                  SingleChildScrollView(
                    controller: _scrollController,
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
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isSick
                                  ? Colors.grey.shade300
                                  : Colors.green.shade200,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: isSick
                                    ? Colors.orange
                                    : Colors.amber,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  state.dailyTip,
                                  style: TextStyle(
                                    color: isSick
                                        ? Colors.grey.shade800
                                        : Colors.green.shade800,
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
                          sickThreshold: 50,
                        ),

                        const SizedBox(height: 30),

                        DashboardCard(
                          totalDist: state.totalDistance,
                          totalCarbon: state.totalCarbon,
                        ),

                        const SizedBox(height: 30),

                        const TripHistoryList(),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),

                  // Floating Action Button
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    bottom: _isButtonVisible ? 20 : -100,
                    left: 20,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSick
                                ? Colors.grey.shade700
                                : Colors.green.shade700,
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
                                builder: (context) =>
                                    const TripEntryScreen(),
                              ),
                            ).then((_) {
                              // ✨✨ แก้ไขตรงนี้:  ใช้ resumeAmbience แทน playAmbience ✨✨
                              if (context.mounted) {
                                final state = context
                                    .read<TripCubit>()
                                    .state;
                                if (state is TripLoaded) {
                                  final isSick = state.totalCarbon >= 50.0;
                                  SoundService.resumeAmbience(
                                    isSick: isSick,
                                  ); // ✅ ใช้ method ใหม่
                                }
                              }
                            });
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
                  ),
                ],
              );
            }

            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFA5D6A7), Color(0xFFE8F5E9)],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          },
        ),
      ),
    );
  }
}
