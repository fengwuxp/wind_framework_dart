import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';
import 'package:wind_api_signature/src/api_sign_algorithm.dart';
import 'package:wind_api_signature/src/api_signature_request.dart';
import 'package:wind_api_signature/src/rsa_keys.dart';

void main() {
  group('ApiSignAlgorithm Tests', () {
    late ApiSignatureRequest request;

    setUp(() {
      // 初始化 ApiSignatureRequest 对象，供每个测试使用
      request = ApiSignatureRequest(
        method: 'POST',
        requestPath: '/api/v1/test',
        nonce: '1234567890abcdef',
        timestamp: '1627384956',
        queryString: 'param1=value1&param2=value2',
        requestBody: '{"key": "value"}',
      );
    });

    test('HmacSHA256 Sign and Verify', () {
      const secretKey = 'test-secret-key';

      // 生成 HMAC-SHA256 签名
      final signature = ApiSignAlgorithm.hmacSHA256.sign(request, secretKey);
      // 验证签名
      final isValid = ApiSignAlgorithm.hmacSHA256.verify(request, secretKey, signature);

      expect(isValid, isTrue, reason: 'HmacSHA256 signature should be valid');
    });

    test('SHA256WithRSA Sign and Verify', () {
      // 生成 RSA 密钥对
      AsymmetricKeyPair<PublicKey, PrivateKey> keyPair = getRsaKeyPair(getSecureRandom());

      // 获取公钥和私钥
      RSAPublicKey publicKey = keyPair.publicKey as RSAPublicKey;
      RSAPrivateKey privateKey = keyPair.privateKey as RSAPrivateKey;

      // 生成 SHA256WithRSA 签名
      final signature = ApiSignAlgorithm.sHA256WithRSA.sign(request, encodePrivateKeyToPemPKCS1(privateKey));
      // 验证签名
      final isValid = ApiSignAlgorithm.sHA256WithRSA.verify(request, encodePublicKeyToPemPKCS1(publicKey), signature);

      expect(isValid, isTrue, reason: 'SHA256WithRSA signature should be valid');
    });
  });
}
