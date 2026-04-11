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

  /// Ejecuta la acción principal del formulario:

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
      appBar: AppBar(
        title: Text(_isLoginMode ? 'Iniciar sesión' : 'Crear cuenta'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'MenuFlow',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLoginMode
                        ? 'Accede a tu cuenta para continuar'
                        : 'Crea una cuenta para empezar',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  /// Campo nombre.
                  if (!_isLoginMode) ...[
                    TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (_isLoginMode) {
                          return null;
                        }

                        final text = value?.trim() ?? '';

                        if (text.isEmpty) {
                          return 'Introduce tu nombre';
                        }

                        if (text.length < 2) {
                          return 'El nombre es demasiado corto';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  /// Campo email.
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';

                      if (text.isEmpty) {
                        return 'Introduce tu email';
                      }

                      if (!text.contains('@')) {
                        return 'Introduce un email válido';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Campo contraseña.
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (_) {
                      if (!authState.isLoading) {
                        _submit();
                      }
                    },
                    validator: (value) {
                      final text = value?.trim() ?? '';

                      if (text.isEmpty) {
                        return 'Introduce tu contraseña';
                      }

                      if (text.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  /// Mensaje de error de autenticación.
                  ///
                  /// Se muestra solo cuando el notifier expone un error.
                  if (authState.errorMessage != null) ...[
                    Text(
                      authState.errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                  ],

                  /// Botón principal.
                  ///
                  /// Se desactiva mientras hay una operación en curso.
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _submit,
                      child: authState.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _isLoginMode ? 'Iniciar sesión' : 'Registrarse',
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Botón secundario para alternar entre login y registro.
                  TextButton(
                    onPressed: authState.isLoading ? null : _toggleMode,
                    child: Text(
                      _isLoginMode
                          ? '¿No tienes cuenta? Crear cuenta'
                          : '¿Ya tienes cuenta? Iniciar sesión',
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
}