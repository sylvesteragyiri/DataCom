import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/redis_models.dart';
import '../services/redis_repository.dart';

final redisRepositoryProvider = Provider<RedisRepository>((ref) {
  return MockRedisRepository();
});

final redisOverviewProvider = FutureProvider.family<RedisOverview, String>((ref, connectionId) {
  return ref.watch(redisRepositoryProvider).getOverview(connectionId);
});
