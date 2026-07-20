import 'dart:convert';

import 'package:http/http.dart' as http;

/// Sanity project identity — same project/dataset as the existing Flutter
/// app (see `~/dev/hlvs/app/lib/sanity_config.dart`).
abstract class SanityConfig {
  static const String projectId = 'f537tj40';
  static const String dataset = 'production';
  static const String apiVersion = 'v2021-10-21';
}

/// Thin wrapper around the Sanity query HTTP API. Only ever called from
/// server-side/build-time code (page components, [ContentRepository]
/// implementations) — never import this from an `@client` component, or it
/// will be pulled into the browser bundle.
class SanityClient {
  const SanityClient();

  /// Runs a GROQ [query], optionally with `$param` bindings, and returns the
  /// decoded `result` value (a `Map`, `List`, or `null` depending on query).
  Future<dynamic> fetch(String query, [Map<String, dynamic>? params]) async {
    final queryParams = {'query': query};
    params?.forEach((name, value) {
      queryParams['\$$name'] = jsonEncode(value);
    });

    final uri = Uri.https(
      '${SanityConfig.projectId}.api.sanity.io',
      '/${SanityConfig.apiVersion}/data/query/${SanityConfig.dataset}',
      queryParams,
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw SanityException('Query failed (${response.statusCode}): ${response.body}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    return decoded['result'];
  }
}

class SanityException implements Exception {
  final String message;
  SanityException(this.message);

  @override
  String toString() => 'SanityException: $message';
}
