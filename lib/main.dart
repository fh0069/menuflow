import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:menuflow/features/weekly_plan/presentation/pages/weekly_plan_page.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MenuflowApp(),
    ),
  );
}

class MenuflowApp extends StatelessWidget {
  const MenuflowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WeeklyPlanPage(familyId: 'family_test_001'),
    );
  }
}
