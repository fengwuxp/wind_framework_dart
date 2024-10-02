import 'dart:async';

import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/client/delegate_client_http_request.dart';
import 'package:wind_http/src/http/enums/http_method.dart';

/// 缓存 request body 的请求，支持重复发起请求
class CacheRequestBodyClientHttpRequest extends DelegateClientHttpRequest {
  final List<int> requestBody = [];

  StreamSink<List<int>>? _body;

  CacheRequestBodyClientHttpRequest(super.delegate);

  @override
  Future<ClientHttpResponse> send() async {
    if (HttpMethod.supportRequestBody(method) && requestBody.isEmpty) {
      await _cacheRequestBody();
    }
    // 重新创建 Body
    _body = StreamController<List<int>>(sync: true);
    _body?.add(requestBody);
    return super.send();
  }

  @override
  StreamSink<List<int>> get body => _body!;

  Future<void> _cacheRequestBody() async {
    final body = delegate.body;
    if (body is StreamController<List<int>>) {
      body.stream.listen((bytes) {
        requestBody.addAll(bytes);
      });
    }
    await body.close();
  }
}
