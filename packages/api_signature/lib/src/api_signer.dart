import 'package:wind_api_signature/src/api_signature_request.dart';

/// Api Signer
///
/// Author: wuxp
/// Date: 2024-02-23 12:48
abstract class ApiSigner {
  /// 生成签名
  ///
  /// [request] 是签名请求。
  /// [secretKey] 是签名秘钥。
  /// 返回签名结果。
  String sign(ApiSignatureRequest request, String secretKey);

  /// 签名验证
  ///
  /// [request] 是用于验证签名的请求。
  /// [secretKey] 是签名秘钥。
  /// [signText] 是待验证的签名。
  /// 返回签名验证是否通过。
  bool verify(ApiSignatureRequest request, String secretKey, String signText);
}
