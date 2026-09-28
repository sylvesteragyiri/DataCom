import '../models/credential_models.dart';
import '../models/status_level.dart';

abstract class CredentialsRepository {
  Future<List<Credential>> getCredentials();
}

class MockCredentialsRepository implements CredentialsRepository {
  @override
  Future<List<Credential>> getCredentials() async => const [
    Credential(
      name: 'Cloudflare API token',
      provider: 'Cloudflare',
      abbr: 'CF',
      field: 'API token',
      state: 'SET',
      level: StatusLevel.ok,
      masked: 'cf_live_••••••••••••4f2a',
      secret: 'cf_live_91ka03Zx8dQm7bT2vR4f2a',
      scope: 'Zone.Read, Workers.Read, Analytics.Read',
    ),
    Credential(
      name: 'Vercel access token',
      provider: 'Vercel',
      abbr: 'VC',
      field: 'Access token',
      state: 'SET',
      level: StatusLevel.ok,
      masked: 'vc_•••••••••••••••••••9b17',
      secret: 'vc_8Hq2LmZ04pXe71aRtY9b17',
      scope: 'read:deployments, read:logs',
    ),
    Credential(
      name: 'Sentry auth token',
      provider: 'Sentry',
      abbr: 'SY',
      field: 'Auth token',
      state: 'SET',
      level: StatusLevel.ok,
      masked: 'sntrys_•••••••••••••02ac',
      secret: 'sntrys_eyJpYXQiOjE3MzQzMjEwMDJhYw',
      scope: 'project:read, event:read',
    ),
    Credential(
      name: 'assets-prod access key',
      provider: 'AWS S3',
      abbr: 'S3',
      field: 'Secret access key',
      state: 'SET',
      level: StatusLevel.ok,
      masked: 'AKIA•••••••••••••7Q4D',
      secret: 'AKIAQ3M7PLZR29XV7Q4D',
      scope: 's3:GetObject, s3:ListBucket',
    ),
    Credential(
      name: 'media-cdn access key',
      provider: 'Cloudflare R2',
      abbr: 'R2',
      field: 'Secret access key',
      state: 'MISSING',
      level: StatusLevel.critical,
      masked: 'not set',
      secret: '',
      scope: '',
    ),
    Credential(
      name: 'Nightwatch token',
      provider: 'Nightwatch',
      abbr: 'NW',
      field: 'API token',
      state: 'MISSING',
      level: StatusLevel.warn,
      masked: 'not set',
      secret: '',
      scope: '',
    ),
  ];
}
