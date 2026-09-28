import '../models/console_emphasis.dart';
import '../models/status_level.dart';
import '../models/vercel_models.dart';

abstract class VercelRepository {
  Future<VercelOverview> getOverview(String connectionId);
}

class MockVercelRepository implements VercelRepository {
  @override
  Future<VercelOverview> getOverview(String connectionId) async => const VercelOverview(
    deployments: [
      Deployment(
        sha: '9fK2a41',
        state: 'BUILDING',
        level: StatusLevel.warn,
        message: 'fix: guard missing shipping on cart summary',
        branch: 'main',
        duration: '1m 12s',
        ago: 'now',
      ),
      Deployment(
        sha: '7cD8f02',
        state: 'ERROR',
        level: StatusLevel.critical,
        message: 'feat: new checkout summary',
        branch: 'main',
        duration: '2m 41s',
        ago: '42m ago',
      ),
      Deployment(
        sha: '22aB19c',
        state: 'READY',
        level: StatusLevel.ok,
        message: 'chore: bump deps',
        branch: 'main',
        duration: '2m 08s',
        ago: '5h ago',
      ),
      Deployment(
        sha: '0e91Bc4',
        state: 'READY',
        level: StatusLevel.ok,
        message: 'fix: pricing rounding',
        branch: 'main',
        duration: '1m 58s',
        ago: 'yesterday',
      ),
    ],
    buildLog: [
      LogLine('14:41:02', 'Cloning github.com/acme/storefront (main)'),
      LogLine('14:41:06', 'Restored build cache in 1.2s', ConsoleEmphasis.muted),
      LogLine('14:41:09', 'Running "npm run build"'),
      LogLine('14:41:24', '▲ Next.js 15.3.1', ConsoleEmphasis.muted),
      LogLine('14:41:52', 'Creating an optimized production build'),
      LogLine('14:42:31', '✓ Compiled successfully in 39s', ConsoleEmphasis.success),
      LogLine('14:42:33', 'Collecting page data'),
      LogLine('14:42:48', '⚠ Large page data on /checkout (218 kB)', ConsoleEmphasis.warn),
      LogLine('14:42:55', 'Generating static pages (41/41)'),
      LogLine('14:43:01', 'Uploading build outputs…', ConsoleEmphasis.muted),
    ],
  );
}
