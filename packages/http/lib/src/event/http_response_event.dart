import 'dart:io';

import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_response.dart';

abstract class HttpResponseEventPublisher {
  publishEvent(ClientHttpRequest request, ClientHttpResponse response);
}

typedef HttpResponseEventHandler = void Function(ClientHttpRequest request, ClientHttpResponse response);

abstract class HttpResponseEventHandlerSupplier {
  List<HttpResponseEventHandler> getHandlers(int status);
}

abstract class HttpResponseEventListener extends HttpResponseEventHandlerSupplier {
  /// 回调指定的的 http status handler
  void onEvent(int status, HttpResponseEventHandler handler);

  /// 移除监听
  void removeListen(int status, HttpResponseEventHandler? handler);
}

abstract class SmartHttpResponseEventListener extends HttpResponseEventListener {
  ///  所有非 2xx 响应都会回调
  void onError(HttpResponseEventHandler handler);

  void removeErrorListen(HttpResponseEventHandler handler);

  /// [HttpStatus.found]
  void onFound(HttpResponseEventHandler handler);

  /// [HttpStatus.unauthorized]
  void onUnAuthorized(HttpResponseEventHandler handler);

  /// [HttpStatus.forbidden]
  void onForbidden(HttpResponseEventHandler handler);
}
