import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_request_factory.dart';
import 'package:wind_http/src/client/client_http_request_interceptor.dart';
import 'package:wind_http/src/client/default_client_http_request.dart';
import 'package:wind_http/src/client/intercepting_client_http_request.dart';
import 'package:wind_http/src/http/converter/http_message_converter.dart';
import 'package:wind_http/src/http/http_request_context.dart';

/// 默认 [ClientHttpRequestFactory] 工厂
class DefaultClientHttpRequestFactory implements ClientHttpRequestFactory {
  final List<HttpMessageConverter> httpMessageConverters;

  final List<ClientHttpRequestInterceptor> interceptors;

  DefaultClientHttpRequestFactory(this.httpMessageConverters, this.interceptors);

  @override
  ClientHttpRequest createRequest(Uri uri, String httpMethod,
      {dynamic requestBody, Map<String, String>? headers, HttpRequestContext? context}) {
    final request = DefaultClientHttpRequest(uri, httpMethod,
        requestBody: requestBody, httpMessageConverters: httpMessageConverters, headers: headers, context: context);
    return InterceptingClientHttpRequest(request, interceptors.iterator);
  }
}
