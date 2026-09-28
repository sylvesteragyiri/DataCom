class StorageObject {
  const StorageObject({
    required this.name,
    required this.ext,
    required this.size,
    required this.modified,
  });

  final String name;
  final String ext;
  final String size;
  final String modified;
}
