import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/storage_models.dart';
import '../services/storage_repository.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return MockStorageRepository();
});

final bucketObjectsProvider = FutureProvider.family<List<StorageObject>, String>((ref, bucketId) {
  return ref.watch(storageRepositoryProvider).getObjects(bucketId);
});
