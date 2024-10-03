import 'package:wind_api_signature/src/api_signature_request.dart';
import 'package:wind_api_signature/src/api_signer.dart';
import 'package:wind_api_signature/src/hmac_sha256_signer.dart';
import 'package:wind_api_signature/src/sha256_with_rsa_signer.dart';

/// ApiSignAlgorithm 枚举的实现
class ApiSignAlgorithm implements ApiSigner {
  final String algorithm;

  final ApiSigner delegate;

  const ApiSignAlgorithm(this.algorithm, this.delegate);

  static const hmacSHA256 = ApiSignAlgorithm('HmacSHA256', HmacSHA256Signer());

  static const sHA256WithRSA = ApiSignAlgorithm('SHA256WithRSA', Sha256WithRsaSigner());

  @override
  String sign(ApiSignatureRequest request, String secretKey) {
    return delegate.sign(request, secretKey);
  }

  @override
  bool verify(ApiSignatureRequest request, String secretKey, String sign) {
    return delegate.verify(request, secretKey, sign);
  }
}
