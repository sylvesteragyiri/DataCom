import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/alert_models.dart';
import '../services/alerts_repository.dart';

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  return MockAlertsRepository();
});

final alertsProvider = FutureProvider<List<Alert>>((ref) {
  return ref.watch(alertsRepositoryProvider).getAlerts();
});

final issuesProvider = FutureProvider<List<Issue>>((ref) {
  return ref.watch(alertsRepositoryProvider).getIssues();
});

final alertByIdProvider = Provider.family<AsyncValue<Alert?>, int>((ref, id) {
  final alerts = ref.watch(alertsProvider);
  return alerts.whenData((list) {
    for (final alert in list) {
      if (alert.id == id) return alert;
    }
    return null;
  });
});
