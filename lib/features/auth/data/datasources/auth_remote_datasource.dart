import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';

import '../../../../features/weekly_plan/data/models/weekly_plan_model.dart';
import '../models/app_user_model.dart';

/// Define las operaciones de acceso a datos para autenticación.
abstract class AuthRemoteDataSource {
  Stream<UserModel?> authStateChanges();
  Future<UserModel?> getCurrentUser();
  Future<UserModel> register(String name, String email, String password);
  Future<UserModel> login(String email, String password);
  Future<void> logout();
}

/// Implementación que utiliza Firebase Auth y Firestore.
/// - Documento de usuario en users/{uid}
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._auth, this._firestore);

  @override
  Stream<UserModel?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return _fetchUserModel(firebaseUser.uid);
    });
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    return _fetchUserModel(firebaseUser.uid);
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      final now = DateTime.now();

      // El familyId inicial es el propio uid del usuario.
      // Cuando se implemente la feature de familias, este valor
      // podrá actualizarse para unirse a una familia existente.
      final familyId = uid;

      final model = UserModel(
        id: uid,
        name: name,
        email: email,
        registrationDate: now,
        familyId: familyId,
        role: 'admin',
      );

      final initialPlan = WeeklyPlanModel(
        id: familyId,
        familyId: familyId,
        weekStartDate: DateTime(now.year, now.month, now.day)
            .subtract(Duration(days: now.weekday - 1)),
        creationDate: now,
        meals: const {},
      );

      // Escribe ambos documentos en paralelo para reducir latencia.
      await Future.wait([
        _firestore.collection('users').doc(uid).set(model.toMap()),
        _firestore
            .collection('weekly_plans')
            .doc(familyId)
            .set(initialPlan.toMap()),
      ]);

      return model;
    } catch (e) {
      debugPrint('AuthRemoteDataSource.register error: $e');
      throw Exception('Error al registrar el usuario: $e');
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return _fetchUserModel(credential.user!.uid);
    } catch (e) {
      debugPrint('AuthRemoteDataSource.login error: $e');
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('AuthRemoteDataSource.logout error: $e');
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  Future<UserModel> _fetchUserModel(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        throw Exception(
          'No se encontró el documento del usuario en Firestore: $uid',
        );
      }

      return UserModel.fromMap(uid, doc.data()!);
    } catch (e) {
      debugPrint('AuthRemoteDataSource._fetchUserModel error: $e');
      throw Exception('Error al obtener el usuario: $e');
    }
  }
}