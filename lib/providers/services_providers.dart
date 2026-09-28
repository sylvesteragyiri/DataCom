import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/service_models.dart';
import '../services/services_repository.dart';

final servicesRepositoryProvider = Provider<ServicesRepository>((ref) {
  return MockServicesRepository();
});

final servicesOverviewProvider = FutureProvider<ServicesOverview>((ref) {
  return ref.watch(servicesRepositoryProvider).getOverview();
});
