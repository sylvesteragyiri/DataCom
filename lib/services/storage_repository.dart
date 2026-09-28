import '../models/storage_models.dart';

abstract class StorageRepository {
  Future<List<StorageObject>> getObjects(String bucketId);
}

class MockStorageRepository implements StorageRepository {
  @override
  Future<List<StorageObject>> getObjects(String bucketId) async => const [
    StorageObject(name: 'hero-summer-2026.webp', ext: 'WEBP', size: '482 kB', modified: '2026-08-05 12:04'),
    StorageObject(name: 'catalog-export-full.csv', ext: 'CSV', size: '184 MB', modified: '2026-08-05 06:00'),
    StorageObject(name: 'invoice-84220913.pdf', ext: 'PDF', size: '112 kB', modified: '2026-08-04 22:41'),
    StorageObject(name: 'product-3418-detail.jpg', ext: 'JPG', size: '1.2 MB', modified: '2026-08-04 19:08'),
    StorageObject(
      name: 'backup-orders-0805.sql.gz',
      ext: 'GZ',
      size: '2.8 GB',
      modified: '2026-08-04 03:00',
    ),
    StorageObject(name: 'sitemap.xml', ext: 'XML', size: '88 kB', modified: '2026-08-03 11:20'),
  ];
}
