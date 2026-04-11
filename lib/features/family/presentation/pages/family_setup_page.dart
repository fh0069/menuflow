import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import 'create_family_page.dart';
import 'join_family_page.dart';

/// Color de marca principal de MenuFlow (verde/teal del diseño).
const _kBrandColor = Color(0xFF00C896);

/// Pantalla de configuración inicial de familia.
///
/// Se muestra cuando el usuario ya está autenticado pero todavía no
/// pertenece a ninguna familia. Ofrece dos caminos:
///   1. Crear una familia nueva → [CreateFamilyPage]
///   2. Unirse a una existente con código → [JoinFamilyPage]
class FamilySetupPage extends ConsumerWidget {
  const FamilySetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Logo / cabecera ──────────────────────────────────────────
              Row(
                children: [
                  Icon(Icons.restaurant_menu, color: _kBrandColor, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'MenuFlow',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _kBrandColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ── Título principal ─────────────────────────────────────────
              Text(
                '¡Bienvenido a tu\nplanificador!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Organiza tus menús semanales\nde forma colaborativa.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),

              const SizedBox(height: 40),

              // ── Tarjeta: Crear una familia ───────────────────────────────
              _SetupCard(
                icon: Icons.home_outlined,
                title: 'Crear una familia',
                description:
                    'Empieza un nuevo grupo familiar desde cero y gestiona tus comidas.',
                buttonLabel: 'Comenzar',
                buttonFilled: true,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CreateFamilyPage()),
                ),
              ),

              const SizedBox(height: 16),

              // ── Tarjeta: Unirse con código ───────────────────────────────
              _SetupCard(
                icon: Icons.vpn_key_outlined,
                title: 'Unirme con código',
                description:
                    'Usa un código que te haya enviado un administrador para entrar.',
                buttonLabel: 'Introducir código',
                buttonFilled: false,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const JoinFamilyPage()),
                ),
              ),

              const Spacer(),

              // ── Cerrar sesión ────────────────────────────────────────────
              TextButton.icon(
                onPressed: () =>
                    ref.read(authNotifierProvider.notifier).logout(),
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Cerrar sesión'),
                style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
              ),

              const SizedBox(height: 8),
              Text(
                '© 2024 MenuFlow · Gestión Familiar',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[400]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widget interno: tarjeta de opción ────────────────────────────────────────

class _SetupCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final bool buttonFilled;
  final VoidCallback onTap;

  const _SetupCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.buttonFilled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icono con fondo de color suave
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F8F3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _kBrandColor, size: 24),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  height: 1.4,
                ),
          ),

          const SizedBox(height: 20),

          // Botón principal o secundario según la opción
          buttonFilled
              ? ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kBrandColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(buttonLabel),
                )
              : OutlinedButton(
                  onPressed: onTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFDDDDDD)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(buttonLabel),
                ),
        ],
      ),
    );
  }
}
