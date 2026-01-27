import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbocare/core/services/sound_service.dart';
import 'package:carbocare/core/widgets/earth_avatar_widget.dart';
import 'package:carbocare/features/daily_tips/presentation/cubit/trip_cubit.dart';

import 'package:carbocare/features/daily_tips/presentation/widgets/dashboard_card.dart';
import 'package:carbocare/features/daily_tips/presentation/widgets/trip_history_list.dart';
import 'package:carbocare/core/widgets/carbon_status_widget.dart';
import 'package:carbocare/features/daily_tips/presentation/widgets/feed_menu.dart';
import 'package:carbocare/features/daily_tips/presentation/widgets/earth_speech_bubble.dart';

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
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isButtonVisible) setState(() => _isButtonVisible = false);
      } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!_isButtonVisible) setState(() => _isButtonVisible = true);
      }
    });
  }

  @override
  void dispose() {
    SoundService.stopAmbience();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // -----------------------------------------------------------
            // 🎨 ส่วนที่ 1: พื้นหลัง (Dynamic: เปลี่ยนสีตามสถานะ)
            // -----------------------------------------------------------
            BlocBuilder<TripCubit, TripState>(
              buildWhen: (previous, current) {
                if (previous is TripLoaded && current is TripLoaded) {
                  bool wasSick = previous.totalCarbon >= 50;
                  bool isSick = current.totalCarbon >= 50;
                  return wasSick != isSick;
                }
                return true;
              },
              builder: (context, state) {
                bool isSick = false;
                if (state is TripLoaded) {
                  isSick = state.totalCarbon >= 50.0;
                  SoundService.playAmbience(isSick: isSick);
                }

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isSick
                          ? [const Color(0xFF4A4A4A), const Color(0xFFB0B0B0)]
                          : [const Color(0xFFA5D6A7), const Color(0xFFE8F5E9)],
                    ),
                  ),
                );
              },
            ),

            // -----------------------------------------------------------
            // 📦 ส่วนที่ 2: เนื้อหา (Content)
            // -----------------------------------------------------------
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // 2.1 Speech Bubble
                  BlocBuilder<TripCubit, TripState>(
                    builder: (context, state) {
                      if (state is! TripLoaded) return const SizedBox();
                      final isSick = state.totalCarbon >= 50.0;
                      
                      return EarthSpeechBubble(
                        message: state.dailyTip,
                        isSick: isSick,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // 2.2 น้องโลก
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<TripCubit, TripState>(
                      builder: (context, state) {
                        if (state is! TripLoaded) return const CircularProgressIndicator();
                        
                        return EarthAvatarWidget(
                          totalCarbon: state.totalCarbon,
                          sickThreshold: 50.0,
                          onItemReceived: (itemType, impact, isHealing) {
                            context.read<TripCubit>().feedEarth(itemType, impact, isHealing);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 2.3 เมนูอาหาร
                  const FeedMenuWidget(),

                  const SizedBox(height: 30),

                  // 2.4 สถิติต่างๆ
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: BlocBuilder<TripCubit, TripState>(
                      builder: (context, state) {
                        if (state is! TripLoaded) return const SizedBox();
                        
                        return Column(
                          children: [
                            CarbonLevelCard(
                              totalCarbon: state.totalCarbon,
                              maxLimit: 100.0,
                              sickThreshold: 50,
                            ),
                            const SizedBox(height: 30),
                            
                            // ✨✨ แก้ไขตรงนี้: ส่ง goodActions/badActions แทน ✨✨
                            DashboardCard(
                              goodCount: state.goodActions,
                              badCount: state.badActions,
                            ),
                            
                            const SizedBox(height: 30),
                            const TripHistoryList(),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}