import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_response.dart';

import 'http_response_event.dart';

class SimpleHttpResponseEventPublisher implements HttpResponseEventPublisher {
  final HttpResponseEventHandlerSupplier _eventHandlerSupplier;

  SimpleHttpResponseEventPublisher(this._eventHandlerSupplier);

  @override
  publishEvent(ClientHttpRequest request, ClientHttpResponse response) {
    _eventHandlerSupplier.getHandlers(response.statusCode).forEach((handler) {
      handler(request, response);
    });
  }
}
