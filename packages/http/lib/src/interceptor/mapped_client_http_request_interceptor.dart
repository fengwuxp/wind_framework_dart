import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_request_interceptor.dart';
import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/interceptor/mapped_interceptor.dart';

class MappedClientHttpRequestInterceptor extends MappedInterceptor implements ClientHttpRequestInterceptor {
  final ClientHttpRequestInterceptor _clientInterceptor;

  MappedClientHttpRequestInterceptor(ClientHttpRequestInterceptor clientHttpRequestInterceptor,
      {super.includePatterns,
      super.excludePatterns,
      super.includeMethods,
      super.excludeMethods,
      super.includeHeaders,
      super.excludeHeaders})
      : _clientInterceptor = clientHttpRequestInterceptor;

  @override
  Future<ClientHttpResponse> intercept(ClientHttpRequest request, ClientHttpRequestExecution next) {
    return _clientInterceptor.intercept(request, next);
  }

}
