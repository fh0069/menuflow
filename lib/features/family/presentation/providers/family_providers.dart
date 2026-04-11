import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/firebase_providers.dart';
import '../../data/datasources/family_remote_datasource.dart';
import '../../data/repositories/family_repository_impl.dart';
import '../../domain/repositories/family_repository.dart';
import '../../domain/usecases/join_family.dart';

final familyRemoteDataSourceProvider =
    Provider<FamilyRemoteDataSource>((ref) {
  return FamilyRemoteDataSourceImpl(ref.watch(firestoreProvider));
});

final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  return FamilyRepositoryImpl(ref.watch(familyRemoteDataSourceProvider));
});

final joinFamilyProvider = Provider<JoinFamily>((ref) {
  return JoinFamily(ref.watch(familyRepositoryProvider));
});
