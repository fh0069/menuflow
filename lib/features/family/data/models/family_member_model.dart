import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/family_member.dart';

class FamilyMemberModel extends FamilyMember {
  const FamilyMemberModel({
    required super.userId,
    required super.role,
    required super.joinDate,
  });

  factory FamilyMemberModel.fromMap(Map<String, dynamic> map) {
    return FamilyMemberModel(
      userId: map['userId'] as String,
      role: _roleFromString(map['role'] as String),
      joinDate: (map['joinDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'role': _roleToString(role),
      'joinDate': Timestamp.fromDate(joinDate),
    };
  }

  factory FamilyMemberModel.fromEntity(FamilyMember entity) {
    return FamilyMemberModel(
      userId: entity.userId,
      role: entity.role,
      joinDate: entity.joinDate,
    );
  }

  static String _roleToString(FamilyRole role) {
    switch (role) {
      case FamilyRole.admin:
        return 'admin';
      case FamilyRole.member:
        return 'member';
    }
  }

  static FamilyRole _roleFromString(String value) {
    switch (value) {
      case 'admin':
        return FamilyRole.admin;
      case 'member':
        return FamilyRole.member;
      default:
        throw ArgumentError('Rol no válido: $value');
    }
  }
}