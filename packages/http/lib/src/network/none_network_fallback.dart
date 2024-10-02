import 'dart:io';

import 'package:wind_http/src/client/client_http_request.dart';

/// Downgrade processing without network
abstract class NoneNetworkFallBack<T extends ClientHttpRequest> {
  ///  Network is closed
  /// @param [request]
  Future<T> onNetworkClose(T request);

  /// Network is activated
  Future<void> onNetworkActive();
}

class DefaultNoneNetworkFailBack<T extends ClientHttpRequest> implements NoneNetworkFallBack<T> {
  @override
  Future<T> onNetworkClose(T request) {
    return Future.error(HttpException("none network", uri: request.url));
  }

  @override
  Future<void> onNetworkActive() async {}
}
