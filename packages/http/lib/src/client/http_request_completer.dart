import 'dart:async';

import 'package:wind_http/src/http/http_request.dart';

/// http request completer
/// 用于某些情况需要阻塞等待请求时使用，例如：网络为就绪，先等待网络连接
class HttpRequestCompleter {
  /// 过期时间，-1 表示不过期
  final int expireTime;

  final HttpRequest request;

  final Completer completer;

  HttpRequestCompleter(this.expireTime, this.request, this.completer);

  bool isExpire(int currentTimes) {
    if (expireTime == -1) {
      return false;
    }
    return expireTime < currentTimes;
  }
}
