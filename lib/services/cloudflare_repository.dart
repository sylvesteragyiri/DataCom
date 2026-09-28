import '../models/cloudflare_models.dart';
import '../models/console_emphasis.dart';
import '../models/status_level.dart';
import '../models/vercel_models.dart';

abstract class CloudflareRepository {
  Future<CloudflareOverview> getOverview(String connectionId);
}

class MockCloudflareRepository implements CloudflareRepository {
  @override
  Future<CloudflareOverview> getOverview(String connectionId) async => const CloudflareOverview(
    metrics: [
      CfMetric('Requests', '84.2 M', 'last 24 h'),
      CfMetric('Cache hit', '98.4%', '2.1 M misses', StatusLevel.ok),
      CfMetric('Bandwidth', '1.42 TB', 'cached 1.38 TB'),
      CfMetric('Threats blocked', '12.4 k', '0.4% of traffic', StatusLevel.warn),
      CfMetric('Origin 5xx', '0.02%', '184 responses', StatusLevel.ok),
      CfMetric('p50 edge TTFB', '42 ms', 'p95 118 ms', StatusLevel.ok),
    ],
    zones: [
      CfZone(name: 'acme.io', plan: 'Pro', records: '42', ssl: 'full (strict)', requests: '61.8 M', level: StatusLevel.ok),
      CfZone(name: 'acme.dev', plan: 'Free', records: '18', ssl: 'flexible', requests: '14.2 M', level: StatusLevel.warn),
      CfZone(
        name: 'acme-cdn.net',
        plan: 'Pro',
        records: '9',
        ssl: 'full (strict)',
        requests: '7.9 M',
        level: StatusLevel.ok,
      ),
      CfZone(name: 'acme-status.io', plan: 'Free', records: '6', ssl: 'full', requests: '312 k', level: StatusLevel.ok),
    ],
    dns: [
      DnsRecord(type: 'A', name: 'acme.io', value: '104.21.44.9', proxy: 'proxied', proxied: true),
      DnsRecord(
        type: 'AAAA',
        name: 'acme.io',
        value: '2606:4700:3033::6815:2c09',
        proxy: 'proxied',
        proxied: true,
      ),
      DnsRecord(type: 'CNAME', name: 'www', value: 'acme.io', proxy: 'proxied', proxied: true),
      DnsRecord(type: 'CNAME', name: 'assets', value: 'media-cdn.r2.dev', proxy: 'proxied', proxied: true),
      DnsRecord(
        type: 'MX',
        name: 'acme.io',
        value: '10 mx1.forwardemail.net',
        proxy: 'dns only',
        proxied: false,
      ),
      DnsRecord(
        type: 'TXT',
        name: '_dmarc',
        value: 'v=DMARC1; p=quarantine; rua=mailto:dmarc@acme.io',
        proxy: 'dns only',
        proxied: false,
      ),
      DnsRecord(type: 'A', name: 'legacy', value: '81.2.44.9', proxy: 'dns only', proxied: false),
    ],
    workers: [
      CfWorker(
        name: 'api-router',
        deployed: '2h ago',
        level: StatusLevel.ok,
        stats: [CfWorkerStat('req / h', '2.1 M'), CfWorkerStat('p95 cpu', '18 ms'), CfWorkerStat('errors', '0.01%')],
      ),
      CfWorker(
        name: 'image-resize',
        deployed: 'yesterday',
        level: StatusLevel.warn,
        stats: [CfWorkerStat('req / h', '842 k'), CfWorkerStat('p95 cpu', '96 ms'), CfWorkerStat('errors', '0.8%')],
      ),
      CfWorker(
        name: 'auth-edge',
        deployed: '4d ago',
        level: StatusLevel.ok,
        stats: [CfWorkerStat('req / h', '611 k'), CfWorkerStat('p95 cpu', '12 ms'), CfWorkerStat('errors', '0.00%')],
      ),
      CfWorker(
        name: 'webhook-fanout',
        deployed: '6d ago',
        level: StatusLevel.critical,
        stats: [
          CfWorkerStat('req / h', '88 k'),
          CfWorkerStat('p95 cpu', '204 ms'),
          CfWorkerStat('errors', '4.2%', true),
        ],
      ),
      CfWorker(
        name: 'ab-assign',
        deployed: '2w ago',
        level: StatusLevel.ok,
        stats: [CfWorkerStat('req / h', '412 k'), CfWorkerStat('p95 cpu', '6 ms'), CfWorkerStat('errors', '0.00%')],
      ),
    ],
    workerLog: [
      LogLine('14:43:12', 'GET /v1/orders 200 · 18ms · LHR'),
      LogLine('14:43:12', 'cache HIT assets/hero-summer-2026.webp', ConsoleEmphasis.muted),
      LogLine('14:43:11', 'GET /v1/cart 200 · 24ms · CDG'),
      LogLine('14:43:10', 'subrequest pg-proxy 502 · retry 1', ConsoleEmphasis.warn),
      LogLine('14:43:10', 'GET /v1/cart 200 · 96ms · CDG'),
      LogLine('14:43:08', 'Error: KV namespace SESSIONS rate limited', ConsoleEmphasis.danger),
      LogLine('14:43:08', '  at handleAuth (auth-edge.ts:41)', ConsoleEmphasis.muted),
      LogLine('14:43:07', 'POST /v1/checkout 200 · 142ms · AMS'),
      LogLine('14:43:05', 'purge tag=catalog · 4,118 objects', ConsoleEmphasis.success),
      LogLine('14:43:02', 'GET /v1/products 200 · 11ms · LHR'),
    ],
    security: [
      SecurityEvent(
        action: 'BLOCK',
        level: StatusLevel.critical,
        rule: 'Managed rules · SQLi probe',
        count: '4,182',
        ago: '12m ago',
        detail: '/v1/products?id=1%20OR%201=1 · 81.2.44.9 · RU',
      ),
      SecurityEvent(
        action: 'CHALLENGE',
        level: StatusLevel.warn,
        rule: 'Rate limit · 100 req/min per IP',
        count: '6,204',
        ago: '18m ago',
        detail: '/v1/checkout · 214 unique IPs · datacenter ASN 14061',
      ),
      SecurityEvent(
        action: 'BLOCK',
        level: StatusLevel.critical,
        rule: 'Country block · login endpoints',
        count: '1,412',
        ago: '42m ago',
        detail: '/admin/login · CN, KP · WAF rule fw_9b21',
      ),
      SecurityEvent(
        action: 'SKIP',
        level: StatusLevel.ok,
        rule: 'Allowlist · office egress',
        count: '812',
        ago: '1h ago',
        detail: '92.40.11.0/24 · bypasses managed rules',
      ),
      SecurityEvent(
        action: 'LOG',
        level: StatusLevel.info,
        rule: 'Bot score < 30 observed',
        count: '18,904',
        ago: '2h ago',
        detail: 'verified bots excluded · no action taken',
      ),
    ],
  );
}
