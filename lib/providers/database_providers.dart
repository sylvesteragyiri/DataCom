import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/database_models.dart';
import '../services/database_repository.dart';

final databaseRepositoryProvider = Provider<DatabaseRepository>((ref) {
  return MockDatabaseRepository();
});

final databaseOverviewProvider = FutureProvider.family<DatabaseOverview, String>((ref, connectionId) {
  return ref.watch(databaseRepositoryProvider).getOverview(connectionId);
});

typedef TableKey = ({String connectionId, String tableName});

final tableOverviewProvider = FutureProvider.family<TableOverview, TableKey>((ref, key) {
  return ref.watch(databaseRepositoryProvider).getTable(key.connectionId, key.tableName);
});
