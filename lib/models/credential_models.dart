import 'status_level.dart';

class Credential {
  const Credential({
    required this.name,
    required this.provider,
    required this.abbr,
    required this.field,
    required this.state,
    required this.level,
    required this.masked,
    required this.secret,
    required this.scope,
  });

  final String name;
  final String provider;
  final String abbr;
  final String field;
  final String state;
  final StatusLevel level;
  final String masked;
  final String secret;
  final String scope;
}
