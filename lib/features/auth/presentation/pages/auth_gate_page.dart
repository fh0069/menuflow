import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../family/presentation/pages/family_setup_page.dart';
import '../../../weekly_plan/presentation/pages/weekly_plan_page.dart';
import '../providers/auth_providers.dart';
import 'auth_page.dart';

/// Pantalla de entrada de la aplicación.
///
/// Su responsabilidad es decidir qué mostrar en función del estado
/// de autenticación del usuario:
/// - mientras se carga la sesión → indicador de carga
/// - si el usuario está autenticado → pantalla principal (temporalmente WeeklyPlanPage)
/// - si no está autenticado → pantalla de login/registro (AuthPage)
///
/// Este widget no contiene lógica de negocio ni detalles de infraestructura.
class AuthGatePage extends ConsumerStatefulWidget {
  const AuthGatePage({super.key});

  @override
  ConsumerState<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends ConsumerState<AuthGatePage> {
  @override
  void initState() {
    super.initState();

    // Al iniciar la app, se intenta recuperar la sesión actual.
    // Se usa Future.microtask para evitar problemas de contexto
    // durante el ciclo de vida inicial del widget.
    Future.microtask(() {
      ref.read(authNotifierProvider.notifier).loadCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Observa el estado de autenticación de forma reactiva.
    final authState = ref.watch(authNotifierProvider);

    /// 1. Estado de carga
    ///
    /// Se muestra mientras se está resolviendo si existe una sesión activa.
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    /// 2. Usuario autenticado
    ///
    /// Si el usuario ya tiene familia → pantalla principal con su familyId real.
    /// Si todavía no tiene familia → pantalla de configuración inicial.
    if (authState.isAuthenticated) {
      final familyId = authState.currentUser?.familyId;

      if (familyId != null && familyId.isNotEmpty) {
        return WeeklyPlanPage(familyId: familyId);
      }

      return const FamilySetupPage();
    }

    /// 3. Usuario no autenticado
    ///
    /// Se muestra la pantalla de autenticación.
    return const AuthPage();
  }
}