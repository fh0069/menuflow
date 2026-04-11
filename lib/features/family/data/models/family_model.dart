import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/family.dart';

class FamilyModel extends Family {
  const FamilyModel({
    required super.id,
    required super.name,
    required super.joinCode,
    required super.creationDate,
    required super.country,
    required super.region,
  });

  factory FamilyModel.fromMap(String id, Map<String, dynamic> map) {
    return FamilyModel(
      id: id,
      name: map['name'] as String? ?? '',
      joinCode: map['joinCode'] as String? ?? '',
      creationDate: (map['creationDate'] as Timestamp).toDate(),
      country: map['country'] as String? ?? '',
      region: map['region'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'joinCode': joinCode,
      'creationDate': Timestamp.fromDate(creationDate),
      'country': country,
      'region': region,
    };
  }
}