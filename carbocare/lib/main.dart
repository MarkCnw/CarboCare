import 'package:carbocare/features/daily_tips/presentation/cubit/trip_cubit.dart';
import 'package:carbocare/features/daily_tips/presentation/screens/home_screen.dart';
import 'package:carbocare/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbocare/core/services/isar_service.dart';

// ✅ ลบ import trip_entry_screen ออก (ไม่ใช้แล้ว)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TripCubit(IsarService())..loadTrips(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const OnboardingScreen(), 
      ),
    );
  }
}