import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_models.dart';
import '../services/dashboard_repository.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return MockDashboardRepository();
});

final dashboardOverviewProvider = FutureProvider<DashboardOverview>((ref) {
  return ref.watch(dashboardRepositoryProvider).getOverview();
});
