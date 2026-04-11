import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';

/// Estado inmutable de autenticación.
/// Describe lo que la UI necesita saber:
/// usuario actual, carga y posible error.
class AuthState {
  final User? currentUser;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.currentUser,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => currentUser != null;

  AuthState copyWith({
    User? currentUser,
    bool? isLoading,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      currentUser: clearUser ? null : (currentUser ?? this.currentUser),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Notifier de autenticación.
/// Orquesta el estado visible de la UI delegando en los use cases.
/// No contiene navegación ni detalles de infraestructura.
class AuthNotifier extends StateNotifier<AuthState> {
  final GetCurrentUser _getCurrentUser;
  final RegisterUser _registerUser;
  final LoginUser _loginUser;
  final LogoutUser _logoutUser;

  AuthNotifier({
    required GetCurrentUser getCurrentUser,
    required RegisterUser registerUser,
    required LoginUser loginUser,
    required LogoutUser logoutUser,
  })  : _getCurrentUser = getCurrentUser,
        _registerUser = registerUser,
        _loginUser = loginUser,
        _logoutUser = logoutUser,
        super(const AuthState());

  Future<void> loadCurrentUser() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _getCurrentUser();

      if (user == null) {
        state = state.copyWith(
          isLoading: false,
          clearUser: true,
        );
      } else {
        state = state.copyWith(
          currentUser: user,
          isLoading: false,
        );
      }
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'No se pudo cargar el usuario.',
      );
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _registerUser(
        name: name,
        email: email,
        password: password,
      );

      state = state.copyWith(
        currentUser: user,
        isLoading: false,
      );

      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            'Error al registrarse. Revisa los datos e inténtalo de nuevo.',
      );

      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _loginUser(
        email: email,
        password: password,
      );

      state = state.copyWith(
        currentUser: user,
        isLoading: false,
      );

      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email o contraseña incorrectos.',
      );

      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _logoutUser();

      state = state.copyWith(
        isLoading: false,
        clearUser: true,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cerrar sesión.',
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}