import 'package:wind_http/src/client/client_http_request.dart';

/// An exception caused by an error in a pkg/http client.
class ClientHttpException implements Exception {
  /// error message
  final String message;

  ///  request object
  final ClientHttpRequest request;

  final Object? cause;

  ClientHttpException(this.message, this.request, this.cause);

  factory(String message, ClientHttpRequest request) {
    ClientHttpException(message, request, null);
  }

  @override
  String toString() => message;
}

/// request timeout exception
class ClientTimeOutException extends ClientHttpException {
  ClientTimeOutException(super.message, super.request, super.cause);

  @override
  factory(String message, ClientHttpRequest request) {
    ClientTimeOutException(message, request, null);
  }
}
