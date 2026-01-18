import 'package:carbocare/features/daily_tips/presentation/cubit/trip_cubit.dart';
import 'package:carbocare/features/daily_tips/presentation/screens/home_screen.dart';
import 'package:carbocare/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbocare/core/services/isar_service.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. ย้าย BlocProvider มาครอบ MaterialApp (จุดสูงสุด)
    return BlocProvider(
      create: (context) => TripCubit(IsarService())..loadTrips(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   useMaterial3: true,
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        //   scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        // ),
        // 2. ตรงนี้เรียก HomeScreen เพียวๆ ได้เลย เพราะมี Cubit ครอบอยู่ข้างบนแล้ว
        home: const OnboardingScreen(), 
      ),
    );
  }
}