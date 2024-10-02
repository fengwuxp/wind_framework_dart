import 'dart:async';

import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_request_interceptor.dart';
import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/client/delegate_client_http_request.dart';

/// 支持 [ClientHttpRequestInterceptor] 执行的 [ClientHttpRequest]
class InterceptingClientHttpRequest extends DelegateClientHttpRequest {
  final Iterator<ClientHttpRequestInterceptor> iterator;

  InterceptingClientHttpRequest(super.delegate, this.iterator);

  @override
  Future<ClientHttpResponse> send() {
    return _intercept(delegate);
  }

  Future<ClientHttpResponse> _intercept(ClientHttpRequest request) {
    if (iterator.moveNext()) {
      return iterator.current.intercept(this, (request) {
        // 调用下一个 拦截器
        return _intercept(request);
      });
    } else {
      // 发送请求
      return request.send();
    }
  }
}
