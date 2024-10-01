import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_response.dart';

/// Represents the context of a client-side HTTP request execution.
///  <p>Used to invoke the next interceptor in the interceptor chain,
///  or - if the calling interceptor is last - execute the request itself.
/// Execute the request with the given request attributes and body,
/// and return the response.
/// - [request] the request, containing method, URI, and headers
/// Returns the response
typedef ClientHttpRequestExecution = Future<ClientHttpResponse> Function(
    ClientHttpRequest request);

/// Intercepts client-side HTTP requests. Implementations of this class can be
/// registered with the HTTP client (e.g., using `dio` or similar packages),
/// to modify the outgoing request and/or the incoming response.
///
/// The main entry point for interceptors is the `intercept` method,
/// which allows modifying or observing the HTTP request before it is sent.
abstract class ClientHttpRequestInterceptor {

  /// Intercepts the given HTTP request and returns a response. The given
  /// [ClientHttpRequestInterceptor] allows the interceptor to pass the request
  /// and response to the next entity in the chain.
  /// - [request] the request, containing method, URI, and headers
  /// - [next] the request execution chain
  ///
  /// Returns the response after executing or modifying the request.
  /// Throws an [IOException] in case of I/O errors.
  Future<ClientHttpResponse> interceptor(ClientHttpRequest request, ClientHttpRequestExecution next);
}
