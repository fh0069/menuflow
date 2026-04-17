import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/family_member_model.dart';
import '../models/family_model.dart';
import '../../domain/entities/family_member.dart';

abstract class FamilyRemoteDataSource {
  /// Busca una familia por código de invitación y une al usuario [userId].
  /// Devuelve el [familyId] de la familia encontrada.
  Future<String> joinByCode(String userId, String inviteCode);
}

class FamilyRemoteDataSourceImpl implements FamilyRemoteDataSource {
  final FirebaseFirestore _firestore;

  FamilyRemoteDataSourceImpl(this._firestore);

  @override
  Future<String> joinByCode(String userId, String inviteCode) async {
    try {
      // 1. Busca la familia por inviteCode
      final query = await _firestore
          .collection('families')
          .where('joinCode', isEqualTo: inviteCode)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        throw Exception('No se encontró ninguna familia con ese código.');
      }

      final familyDoc = query.docs.first;
      final family = FamilyModel.fromMap(familyDoc.id, familyDoc.data());

      // 2. Nuevo miembro con rol 'member'
      final member = FamilyMemberModel(
        userId: userId,
        role: FamilyRole.member,
        joinDate: DateTime.now(),
      );

      // 3. Actualiza users/{uid} y crea members/{uid} en paralelo
      await Future.wait([
        _firestore.collection('users').doc(userId).update({
          'familyId': family.id,
          'role': 'member',
        }),
        _firestore
            .collection('families')
            .doc(family.id)
            .collection('members')
            .doc(userId)
            .set(member.toMap()),
      ]);

      return family.id;
    } catch (e) {
      debugPrint('FamilyRemoteDataSource.joinByCode error: $e');
      rethrow;
    }
  }
}