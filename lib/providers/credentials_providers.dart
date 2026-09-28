import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/credential_models.dart';
import '../services/credentials_repository.dart';

final credentialsRepositoryProvider = Provider<CredentialsRepository>((ref) {
  return MockCredentialsRepository();
});

final credentialsProvider = FutureProvider<List<Credential>>((ref) {
  return ref.watch(credentialsRepositoryProvider).getCredentials();
});

final credentialByIndexProvider = Provider.family<AsyncValue<Credential?>, int>((ref, index) {
  final credentials = ref.watch(credentialsProvider);
  return credentials.whenData((list) => index >= 0 && index < list.length ? list[index] : null);
});
