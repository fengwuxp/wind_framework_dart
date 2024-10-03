import 'dart:collection';
import 'dart:convert';
import 'package:crypto/crypto.dart';


class ApiSignatureRequest {
  static const List<String> signeContentTypes = ['application/json', 'application/x-www-form-urlencoded'];

  static const String md5Tag = 'Md5';

  final String method;
  final String requestPath;
  final String nonce;
  final String timestamp;
  final String? queryString;
  final String? requestBody;

  ApiSignatureRequest({
    required this.method,
    required this.requestPath,
    required this.nonce,
    required this.timestamp,
    this.queryString,
    this.requestBody,
  })  : assert(method.isNotEmpty, 'Method must not be empty'),
        assert(requestPath.isNotEmpty, 'Request path must not be empty'),
        assert(nonce.isNotEmpty, 'Nonce must not be empty'),
        assert(timestamp.isNotEmpty, 'Timestamp must not be empty');

  /// 创建实例时自动构造标准化的查询字符串
  factory ApiSignatureRequest.create({
    required String method,
    required String requestPath,
    required String nonce,
    required String timestamp,
    String? queryString,
    String? requestBody,
  }) {
    final canonicalizedQueryString = buildCanonicalizedQueryString(parseQueryParamsAsMap(queryString));
    return ApiSignatureRequest(
      method: method.toUpperCase(),
      requestPath: requestPath,
      nonce: nonce,
      timestamp: timestamp,
      queryString: canonicalizedQueryString,
      requestBody: requestBody,
    );
  }

  /// 获取摘要签名字符串
  String getSignTextForDigest() {
    final buffer = StringBuffer()
      ..write('method=$method&')
      ..write('requestPath=$requestPath&')
      ..write('nonce=$nonce&')
      ..write('timestamp=$timestamp');

    if (queryString != null && queryString!.isNotEmpty) {
      buffer.write('&queryStringMd5=');
      buffer.write(md5.convert(utf8.encode(queryString!)).toString());
    }

    if (requestBody != null && requestBody!.isNotEmpty) {
      buffer.write('&requestBodyMd5=');
      buffer.write(md5.convert(utf8.encode(requestBody!)).toString());
    }

    return buffer.toString();
  }

  /// 获取 Sha256WithRsa 签名字符串
  String getSignTextForSha256WithRsa() {
    return '$method $requestPath\n$timestamp\n$nonce\n${queryString ?? ''}\n${requestBody ?? ''}\n';
  }

  /// 构建按照字典序排序的查询字符串
  static String? buildCanonicalizedQueryString(Map<String, List<String>> queryParams) {
    if (queryParams.isEmpty) return null;

    final sortedParams = SplayTreeMap<String, List<String>>.from(queryParams);
    return sortedParams.entries
        .map((entry) => entry.value.isEmpty ? '${entry.key}=' : entry.value.map((val) => '${entry.key}=$val').join('&'))
        .where((str) => str.isNotEmpty)
        .join('&');
  }

  /// 解析查询字符串为 Map
  static Map<String, List<String>> parseQueryParamsAsMap(String? queryString) {
    final result = <String, List<String>>{};
    if (queryString == null || queryString.isEmpty) return result;

    final parts = queryString.split('&');
    for (var part in parts) {
      final keyValues = part.split('=');
      final key = keyValues[0];
      result.putIfAbsent(key, () => <String>[]).add(keyValues.length == 2 ? keyValues[1] : '');
    }
    return result;
  }

  /// 解码查询字符串
  static String decodeQueryString(String queryString) {
    return Uri.decodeComponent(queryString);
  }

  /// 判断请求体是否需要签名
  static bool signRequireRequestBody(String? contentType) {
    if (contentType == null || contentType.trim().isEmpty) return false;
    return signeContentTypes.any((type) => contentType.startsWith(type));
  }
}
