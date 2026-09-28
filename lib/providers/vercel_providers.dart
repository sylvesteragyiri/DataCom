import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/vercel_models.dart';
import '../services/vercel_repository.dart';

final vercelRepositoryProvider = Provider<VercelRepository>((ref) {
  return MockVercelRepository();
});

final vercelOverviewProvider = FutureProvider.family<VercelOverview, String>((ref, connectionId) {
  return ref.watch(vercelRepositoryProvider).getOverview(connectionId);
});
