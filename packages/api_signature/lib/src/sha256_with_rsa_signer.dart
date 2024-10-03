import 'dart:convert';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:wind_api_signature/src/api_signature_request.dart';
import 'package:wind_api_signature/src/api_signer.dart';
import 'package:wind_api_signature/src/rsa_keys.dart';

final class Sha256WithRsaSigner implements ApiSigner {
  const Sha256WithRsaSigner();

  @override
  String sign(ApiSignatureRequest request, String secretKey) {
    // 生成签名文本
    String signText = request.getSignTextForSha256WithRsa();

    // 创建签名器
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201'); // SHA256 OID
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(parsePrivateKeyFromPem(secretKey)));

    // 签名
    final signature = signer.generateSignature(Uint8List.fromList(utf8.encode(signText)));
    return base64.encode(signature.bytes); // 返回 Base64 编码的签名
  }

  @override
  bool verify(ApiSignatureRequest request, String secretKey, String signText) {
    // 生成待验证的签名文本
    String signTextForVerify = request.getSignTextForSha256WithRsa();
    // 创建验证器
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201'); // SHA256 OID
    signer.init(false, PublicKeyParameter<RSAPublicKey>(parsePublicKeyFromPem(secretKey)));

    final signatureBytes = base64.decode(signText);
    final signature = RSASignature(Uint8List.fromList(signatureBytes));
    return signer.verifySignature(Uint8List.fromList(utf8.encode(signTextForVerify)), signature);
  }


}
