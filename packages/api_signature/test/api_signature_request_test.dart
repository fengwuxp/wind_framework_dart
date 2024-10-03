import 'dart:convert';
import 'package:test/test.dart';
import 'package:crypto/crypto.dart'; // 确保已经添加此包
import 'package:wind_api_signature/src/api_signature_request.dart';

void main() {
  group('ApiSignatureRequest Tests', () {
    late ApiSignatureRequest request;

    setUp(() {
      request = ApiSignatureRequest.create(
        method: 'POST',
        requestPath: '/api/v1/resource',
        nonce: '123456',
        timestamp: '20231018220800',
        queryString: 'foo=bar&baz=qux',
        requestBody: '{"key":"value"}',
      );
    });

    test('创建 ApiSignatureRequest 对象', () {
      expect(request.method, 'POST');
      expect(request.requestPath, '/api/v1/resource');
      expect(request.nonce, '123456');
      expect(request.timestamp, '20231018220800');
      expect(request.queryString, isNotNull);
      expect(request.requestBody, '{"key":"value"}');
    });

    test('生成摘要签名', () {
      final signText = request.getSignTextForDigest();
      expect(signText, contains('method=POST'));
      expect(signText, contains('requestPath=/api/v1/resource'));
      expect(signText, contains('nonce=123456'));
      expect(signText, contains('timestamp=20231018220800'));
      expect(signText, "method=POST&requestPath=/api/v1/resource&nonce=123456&timestamp=20231018220800&queryStringMd5=14e1cac901b3ac023cceb3478d44fdb2&requestBodyMd5=a7353f7cddce808de0032747a0b7be50");
    });

    test('获取 Sha256WithRsa 签名字符串', () {
      final signText = request.getSignTextForSha256WithRsa();
      expect(signText, contains('POST /api/v1/resource'));
      expect(signText, contains('20231018220800'));
      expect(signText, contains('123456'));
      expect(signText, 'POST /api/v1/resource\n'
          '20231018220800\n'
          '123456\n'
          'baz=qux&foo=bar\n'
          '{"key":"value"}\n'
          '');
      expect(signText, contains('{"key":"value"}'));
    });

    test('构建标准化查询字符串', () {
      final queryParams = {
        'baz': ['qux'],
        'aoo': ['bar']
      };
      final canonicalized = ApiSignatureRequest.buildCanonicalizedQueryString(queryParams);
      expect(canonicalized, 'aoo=bar&baz=qux');
    });

    test('判断请求体是否需要签名', () {
      expect(ApiSignatureRequest.signRequireRequestBody('application/json'), isTrue);
      expect(ApiSignatureRequest.signRequireRequestBody('text/plain'), isFalse);
      expect(ApiSignatureRequest.signRequireRequestBody(null), isFalse);
    });
  });
}
