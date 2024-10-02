import 'package:wind_http/src/client/client_http_request_factory.dart';
import 'package:wind_http/src/client/client_http_response.dart';
import 'package:wind_http/src/http/converter/http_message_converter.dart';
import 'package:wind_http/src/http/enums/http_method.dart';
import 'package:wind_http/src/http/http_request_context.dart';
import 'package:wind_http/src/http/response_entity.dart';
import 'package:wind_http/src/http/response_extractor.dart';
import 'package:wind_http/src/rest/default_url_template_handler.dart';
import 'package:wind_http/src/rest/rest_operations.dart';
import 'package:wind_http/src/rest/rest_response_extractor.dart';
import 'package:wind_http/src/rest/uri_template_handler.dart';

// rest template
class RestTemplate implements RestOperations {
  final ClientHttpRequestFactory factory;

  final UriTemplateHandler uriTemplateHandler;

  final List<HttpMessageConverter> httpMessageConverters;

  const RestTemplate(this.factory,
      {this.uriTemplateHandler = const DefaultUriTemplateHandler(), this.httpMessageConverters = const []});

  /// GET
  @override
  Future<T> getForObject<T>(String url, Type responseType,
      {Map<String, dynamic>? queryParams,
      List<dynamic>? pathVariables,
      Map<String, String>? headers,
      int? timeout,
      HttpRequestContext? context}) {
    return execute(url, HttpMethod.get, _httpMessageConverterExtractor<T>(responseType),
        queryParams: queryParams, pathVariables: pathVariables, headers: headers, timeout: timeout, context: context);
  }

  @override
  Future<ResponseEntity<T>> getForEntity<T>(String url,
      {Type? responseType,
      Map<String, dynamic>? queryParams,
      List<dynamic>? pathVariables,
      Map<String, String>? headers,
      int? timeout,
      HttpRequestContext? context}) {
    return execute(url, HttpMethod.get, _responseEntityResponseExtractor(responseType),
        queryParams: queryParams, pathVariables: pathVariables, headers: headers, timeout: timeout, context: context);
  }

  /// HEAD

  @override
  Future<Map<String, String>> headForHeaders(String url,
      {Map<String, dynamic>? queryParams,
      List<dynamic>? pathVariables,
      Map<String, String>? headers,
      int? timeout,
      HttpRequestContext? context}) {
    return execute(url, HttpMethod.head, _headResponseExtractor(),
        queryParams: queryParams, pathVariables: pathVariables, headers: headers, timeout: timeout, context: context);
  }

  /// POST

  @override
  Future<T> postForObject<T>(String url, dynamic request, Type responseType,
      {Map<String, dynamic>? queryParams,
      List<dynamic>? pathVariables,
      Map<String, String>? headers,
      int? timeout,
      HttpRequestContext? context}) {
    return execute(url, HttpMethod.post, _httpMessageConverterExtractor<T>(responseType),
        queryParams: queryParams, pathVariables: pathVariables, headers: headers, timeout: timeout, context: context);
  }

  @override
  Future<ResponseEntity<T>> postForEntity<T>(String url, dynamic request,
      {Type? responseType,
      Map<String, dynamic>? queryParams,
      List<dynamic>? pathVariables,
      Map<String, String>? headers,
      int? timeout,
      HttpRequestContext? context}) {
    return execute(url, HttpMethod.post, _responseEntityResponseExtractor(responseType),
        queryParams: queryParams, pathVariables: pathVariables, headers: headers, timeout: timeout, context: context);
  }

  @override
  Future<void> put(String url, dynamic request,
      {Map<String, dynamic>? queryParams,
      List<dynamic>? pathVariables,
      Map<String, String>? headers,
      int? timeout,
      HttpRequestContext? context}) {
    return execute(url, HttpMethod.put, VoidResponseExtractor(),
        queryParams: queryParams, pathVariables: pathVariables, headers: headers, timeout: timeout, context: context);
  }

  @override
  Future<T> patchForObject<T>(String url, dynamic request,
      {Type? responseType,
      Map<String, dynamic>? queryParams,
      List<dynamic>? pathVariables,
      Map<String, String>? headers,
      int? timeout,
      HttpRequestContext? context}) {
    return execute(url, HttpMethod.patch, _httpMessageConverterExtractor(responseType),
        queryParams: queryParams, pathVariables: pathVariables, headers: headers, timeout: timeout, context: context);
  }

  @override
  Future<void> delete(String url,
      {Map<String, dynamic>? queryParams,
      List<dynamic>? pathVariables,
      Map<String, String>? headers,
      int? timeout,
      HttpRequestContext? context}) {
    return execute(url, HttpMethod.delete, VoidResponseExtractor(),
        queryParams: queryParams, pathVariables: pathVariables, headers: headers, timeout: timeout, context: context);
  }

  @override
  Future<Set<String>> optionsForAllow(String url,
      {Map<String, dynamic>? queryParams,
      List<dynamic>? pathVariables,
      Map<String, String>? headers,
      int? timeout,
      HttpRequestContext? context}) async {
    return execute(url, HttpMethod.delete, OptionsForAllowResponseExtractor(),
        queryParams: queryParams, pathVariables: pathVariables, timeout: timeout, context: context);
  }

  @override
  Future<T> execute<T>(String url, HttpMethod method, ResponseExtractor<T> responseExtractor,
      {dynamic request,
      Map<String, dynamic>? queryParams,
      List<dynamic>? pathVariables,
      Map<String, String>? headers,
      int? timeout,
      HttpRequestContext? context}) async {
    // 处理url， 查询参数
    final uri = uriTemplateHandler.expand(url, queryParams: queryParams ?? {}, pathVariables: pathVariables ?? []);
    final clientHttpRequest = factory.createRequest(uri, method.method,
        requestBody: request, headers: Map.of(headers ?? {}), context: context);
    // 处理请求体
    ClientHttpResponse response;
    try {
      response = await clientHttpRequest.send();
    } catch (e) {
      // 请求异常处理
      rethrow;
    }

    try {
      final result = await responseExtractor.extractData(response) as T;
      if (response.ok) {
        return result;
      } else {
        // http error response
        return Future.error(response);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  HttpMessageConverterExtractor<T> _httpMessageConverterExtractor<T>(Type? responseType) {
    return HttpMessageConverterExtractor<T>(httpMessageConverters, responseType: responseType);
  }

  ResponseEntityResponseExtractor<T> _responseEntityResponseExtractor<T>(Type? responseType) {
    return ResponseEntityResponseExtractor<T>(httpMessageConverters, responseType);
  }

  HeadResponseExtractor _headResponseExtractor<T>() {
    return HeadResponseExtractor();
  }
}
