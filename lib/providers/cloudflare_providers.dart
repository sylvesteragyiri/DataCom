import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cloudflare_models.dart';
import '../services/cloudflare_repository.dart';

final cloudflareRepositoryProvider = Provider<CloudflareRepository>((ref) {
  return MockCloudflareRepository();
});

final cloudflareOverviewProvider = FutureProvider.family<CloudflareOverview, String>((ref, connectionId) {
  return ref.watch(cloudflareRepositoryProvider).getOverview(connectionId);
});
