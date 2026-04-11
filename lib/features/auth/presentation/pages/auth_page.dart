import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_providers.dart';

/// Pantalla de autenticación del MVP.
///
/// Permite:
/// - iniciar sesión
/// - registrar un nuevo usuario
///
/// La pantalla no contiene lógica de negocio ni detalles de infraestructura.
/// Solo se encarga de mostrar el formulario y enviar las acciones al notifier.

// Color de marca reutilizado en esta pantalla.
const _kBrandColor = Color(0xFF00C896);

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Controla si la pantalla está en modo login o registro.
  bool _isLoginMode = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Ejecuta la acción principal del formulario.
  Future<void> _submit() async {
    // Limpia errores anteriores antes de validar y reenviar.
    ref.read(authNotifierProvider.notifier).clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (_isLoginMode) {
      await authNotifier.login(email, password);
    } else {
      await authNotifier.register(name, email, password);
    }
  }

  /// Cambia entre modo login y registro.
  ///
  /// También limpia el posible error visible para evitar que
  /// un mensaje del modo anterior quede arrastrado.
  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });

    ref.read(authNotifierProvider.notifier).clearError();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ── Card principal ────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Logotipo ────────────────────────────────────────
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F8F3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.restaurant_menu,
                              color: _kBrandColor,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Título y subtítulo ──────────────────────────────
                        const Text(
                          'MenuFlow',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Gestiona tu menú con facilidad',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF888888),
                          ),
                        ),

                        const SizedBox(height: 28),
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 24),

                        // ── Encabezado del formulario ───────────────────────
                        Text(
                          _isLoginMode ? 'Iniciar sesión' : 'Crear cuenta',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isLoginMode
                              ? 'Ingresa tus credenciales para continuar'
                              : 'Rellena los datos para registrarte',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF999999),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Campo nombre (solo registro) ────────────────────
                        if (!_isLoginMode) ...[
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              label: 'Nombre',
                              icon: Icons.person_outline,
                            ),
                            validator: (value) {
                              if (_isLoginMode) return null;
                              final text = value?.trim() ?? '';
                              if (text.isEmpty) return 'Introduce tu nombre';
                              if (text.length < 2) return 'El nombre es demasiado corto';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                        ],

                        // ── Campo email ─────────────────────────────────────
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration(
                            label: 'Email',
                            icon: Icons.email_outlined,
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) return 'Introduce tu email';
                            if (!text.contains('@')) return 'Introduce un email válido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),

                        // ── Campo contraseña ────────────────────────────────
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          decoration: _inputDecoration(
                            label: 'Contraseña',
                            icon: Icons.lock_outline,
                          ),
                          onFieldSubmitted: (_) {
                            if (!authState.isLoading) _submit();
                          },
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) return 'Introduce tu contraseña';
                            if (text.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),

                        // ── Mensaje de error ────────────────────────────────
                        if (authState.errorMessage != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF0F0),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              authState.errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // ── Botón principal ─────────────────────────────────
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: authState.isLoading ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _kBrandColor,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  _kBrandColor.withOpacity(0.5),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _isLoginMode
                                        ? 'Iniciar sesión'
                                        : 'Registrarse',
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Enlace toggle login / registro ──────────────────
                        TextButton(
                          onPressed: authState.isLoading ? null : _toggleMode,
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF555555),
                            textStyle: const TextStyle(fontSize: 14),
                          ),
                          child: Text(
                            _isLoginMode
                                ? '¿Eres nuevo? Crear cuenta'
                                : '¿Ya tienes cuenta? Iniciar sesión',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Decoración común para los campos de texto.
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFFAAAAAA), size: 20),
      filled: true,
      fillColor: const Color(0xFFF5F6F8),
      labelStyle: const TextStyle(color: Color(0xFF999999), fontSize: 14),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kBrandColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFFF5252), width: 1.5),
      ),
    );
  }
}
