import 'dart:async';
import 'dart:math' as math;

import 'package:http/http.dart';
import 'package:wind_http/src/client/cache_request_body_client_http_request.dart';
import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/client/delegate_client_http_request.dart';
import 'package:wind_http/src/http/streamed_client_http_response.dart';

/// 支持重试的 [ClientHttpRequest]
class RetryClientHttpRequest extends DelegateClientHttpRequest {
  /// The number of times a request should be retried.
  final int _retries;

  /// The callback that determines whether a request should be retried.
  final bool Function(ClientHttpResponse) _when;

  /// The callback that determines whether a request when an error is thrown.
  final bool Function(dynamic, StackTrace) _whenError;

  /// The callback that determines how long to wait before retrying a request.
  final Duration Function(int) _delay;

  /// The callback to call to indicate that a request is being retried.
  final void Function(int, ClientHttpRequest, ClientHttpResponse?) _onRetry;

  /// Creates a client wrapping [_inner] that retries HTTP requests.
  ///
  /// This retries a failing request [retries] times (3 by default). Note that
  /// `n` retries means that the request will be sent at most `n + 1` times.
  ///
  /// By default, this retries requests whose responses have status code 503
  /// Temporary Failure. If [when] is passed, it retries any request for whose
  /// response [when] returns `true`. If [whenError] is passed, it also retries
  /// any request that throws an error for which [whenError] returns `true`.
  ///
  /// By default, this waits 500ms between the original request and the first
  /// retry, then increases the delay by 1.5x for each subsequent retry. If
  /// [delay] is passed, it's used to determine the time to wait before the
  /// given (zero-based) retry.
  ///
  /// If [onRetry] is passed, it's called immediately before each retry so that
  /// the client has a chance to perform side effects like logging. The
  /// `response` parameter will be null if the request was retried due to an
  /// error for which [whenError] returned `true`.
  RetryClientHttpRequest(
    super.delegate, {
    int retries = 3,
    bool Function(ClientHttpResponse)? when,
    bool Function(dynamic, StackTrace)? whenError,
    Duration Function(int retryCount)? delay,
    void Function(int, ClientHttpRequest, ClientHttpResponse?)? onRetry,
  })  : _retries = retries,
        _when = when ?? ((response) => [502, 503].contains(response.statusCode)),
        _whenError = whenError ?? ((_, __) => false),
        _delay = delay ?? ((retryCount) => const Duration(milliseconds: 500) * math.pow(1.5, retryCount)),
        _onRetry = onRetry ?? ((count, req, resp) {}) {
    RangeError.checkNotNegative(_retries, 'retries');
  }

  @override
  Future<ClientHttpResponse> send() async {
    final request = CacheRequestBodyClientHttpRequest(delegate);
    var i = 0;
    for (;;) {
      ClientHttpResponse? response;
      try {
        response = await request.send();
      } catch (error, stackTrace) {
        if (i == _retries || !_whenError(error, stackTrace)) rethrow;
        // TODO 待优化
        response = StreamedClientHttpResponse(StreamedResponse(Stream.empty(), 500));
      }
      if (i == _retries || !_when(response)) {
        return response;
      }
      // Make sure the response stream is listened to so that we don't leave
      // dangling connections.
      unawaited(response.body.listen((_) {}).cancel().catchError((_) {}));
      await Future.delayed(_delay(i));
      _onRetry(i, request, response);
      i++;
    }
  }
}
