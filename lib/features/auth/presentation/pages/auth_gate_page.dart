import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../family/presentation/pages/family_setup_page.dart';
import '../../../weekly_plan/presentation/pages/weekly_plan_page.dart';
import '../providers/auth_providers.dart';
import 'auth_page.dart';

/// Decide qué pantalla mostrar según el estado de autenticación y si el usuario tiene familia asignada.
class AuthGatePage extends ConsumerStatefulWidget {
  const AuthGatePage({super.key});

  @override
  ConsumerState<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends ConsumerState<AuthGatePage> {
  @override
  void initState() {
    super.initState();

    // Future.microtask evita llamar al notifier durante el ciclo de build inicial.
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Con familia → pantalla principal. Sin familia → configuración inicial.
    if (authState.isAuthenticated) {
      final familyId = authState.currentUser?.familyId;

      if (familyId != null && familyId.isNotEmpty) {
        return WeeklyPlanPage(familyId: familyId);
      }

      return const FamilySetupPage();
    }

    return const AuthPage();
  }
}