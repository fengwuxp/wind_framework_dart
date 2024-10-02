import 'package:wind_http/src/client/client_http_request.dart';
import 'package:wind_http/src/client/client_http_request_interceptor.dart';
import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/context/request_url_mapping.dart';

typedef RouteMappingsSupplier = Future<Map<String, String>> Function();

/// If the url starts with @xxx, replace 'xxx' with the value of name='xxx' in the routeMapping
/// example url='lb://memberModule/find_member  routeMapping = {memberModule:"http://test.a.b.com/member"}
/// ==> 'http://test.a.b.com/member/find_member'
class RoutingClientHttpRequestInterceptor implements ClientHttpRequestInterceptor {
  final RouteMappingsSupplier routeMapping;

  RoutingClientHttpRequestInterceptor(this.routeMapping);

  static form(String apiEntry) {
    return RoutingClientHttpRequestInterceptor(() => Future.value({"default": apiEntry}));
  }

  static fromMapping(Map<String, String> routeMappings) {
    return RoutingClientHttpRequestInterceptor(() => Future.value(routeMappings));
  }

  static fromSupplier(RouteMappingsSupplier supplier) {
    return RoutingClientHttpRequestInterceptor(supplier);
  }

  @override
  Future<ClientHttpResponse> intercept(ClientHttpRequest request, ClientHttpRequestExecution next) {
    return routeMapping().then((routes) {
      request.uri(routing(request.url, routes));
      return Future.value(request);
    }).then(next);
  }
}
