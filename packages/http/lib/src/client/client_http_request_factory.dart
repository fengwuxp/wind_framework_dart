import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/http/http_request_context.dart';

/// Factory for [ClientHttpRequest] objects.
/// Requests are created by the [createRequest] method.
abstract class ClientHttpRequestFactory {
  /// Create a new [http.Request] for the specified URI and HTTP method.
  ///
  /// The returned request can be written to, and then executed by calling
  /// [ClientHttpRequest.send] or [ClientHttpRequest.send].
  ///
  /// - [uri]: the URI to create a request for
  /// - [httpMethod]: the HTTP method to execute
  ///
  /// Returns the created request.
  /// Throws [IOException] in case of I/O errors.
  ClientHttpRequest createRequest(Uri uri, String httpMethod,
      {dynamic requestBody, Map<String, String>? headers, HttpRequestContext? context});
}
