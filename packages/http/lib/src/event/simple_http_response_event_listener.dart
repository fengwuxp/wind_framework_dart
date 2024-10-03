import 'dart:io';

import 'package:wind_http/src/event/http_response_event.dart';



class SimpleHttpResponseEventListener implements SmartHttpResponseEventListener {
  final List<HttpResponseEventHandler> _errorsHandlers = [];
  final Map<String, List<HttpResponseEventHandler>> _handleCaches = {};

  @override
  List<HttpResponseEventHandler> getHandlers(int status) {
    if (status >= HttpStatus.ok && status < HttpStatus.multipleChoices) {
      return _getHandlers(status);
    }
    return [..._getHandlers(status), ..._errorsHandlers];
  }

  List<HttpResponseEventHandler> _getHandlers(int status) {
    return _handleCaches[status.toString()] ?? [];
  }

  @override
  void onError(HttpResponseEventHandler handler) {
    _errorsHandlers.add(handler);
  }

  @override
  void onEvent(int status, HttpResponseEventHandler handler) {
    List<HttpResponseEventHandler> handles = _getHandlers(status);
    handles.add(handler);
    _handleCaches[status.toString()] = handles;
  }

  @override
  void removeListen(int status, HttpResponseEventHandler? handler) {
    if (handler == null) {
      _handleCaches[status.toString()] = [];
    } else {
      _getHandlers(status).remove(handler);
      removeErrorListen(handler);
    }
  }

  @override
  void onForbidden(HttpResponseEventHandler handler) {
    onEvent(HttpStatus.forbidden, handler);
  }

  @override
  void onFound(HttpResponseEventHandler handler) {
    onEvent(HttpStatus.found, handler);
  }

  @override
  void onUnAuthorized(HttpResponseEventHandler handler) {
    onEvent(HttpStatus.unauthorized, handler);
  }

  @override
  void removeErrorListen(HttpResponseEventHandler handler) {
    _errorsHandlers.remove(handler);
  }
}
