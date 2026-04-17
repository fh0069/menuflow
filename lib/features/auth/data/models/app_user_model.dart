import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.registrationDate,
    super.familyId,
    super.role,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    final registrationDate = map['registrationDate'];
    if (registrationDate == null) {
      throw FormatException("Campo requerido ausente en Firestore: 'registrationDate'");
    }
    if (registrationDate is! Timestamp) {
      throw FormatException(
        "Tipo inesperado para 'registrationDate': se esperaba Timestamp, se recibió ${registrationDate.runtimeType}",
      );
    }

    return UserModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      registrationDate: registrationDate.toDate(),
      familyId: map['familyId'] as String?,
      role: map['role'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'registrationDate': Timestamp.fromDate(registrationDate),
      'familyId': familyId,
      'role': role,
    };
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      registrationDate: entity.registrationDate,
      familyId: entity.familyId,
      role: entity.role,
    );
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      registrationDate: registrationDate,
      familyId: familyId,
      role: role,
    );
  }
}
