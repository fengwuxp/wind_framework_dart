import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_request_interceptor.dart';
import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/event/http_response_event.dart';

/// send http event
class HttpResponseEventPublisherInterceptor implements ClientHttpRequestInterceptor {
  final HttpResponseEventPublisher publisher;

  HttpResponseEventPublisherInterceptor(this.publisher);

  @override
  Future<ClientHttpResponse> intercept(ClientHttpRequest request, ClientHttpRequestExecution next) {
    return next(request).then((response) {
      publisher.publishEvent(request, response);
      return response;
    });
  }
}
