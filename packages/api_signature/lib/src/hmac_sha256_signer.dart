import 'package:wind_api_signature/src/api_signature_request.dart';
import 'package:wind_api_signature/src/api_signer.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart'; // 导入 pointycastle 库
import 'package:convert/convert.dart'; // 用于将字节转换为十六进制或 Base64 编码

/// 摘要签名实现
class HmacSHA256Signer implements ApiSigner {
  const HmacSHA256Signer();

  @override
  String sign(ApiSignatureRequest request, String secretKey) {
    // 将密钥和消息转换为 Uint8List
    final key = utf8.encode(secretKey);
    final messageBytes = utf8.encode(request.getSignTextForDigest());

    // 初始化 HMAC
    final hmac = HMac(SHA256Digest(), 64); // 使用 SHA256Digest 生成 HMAC
    hmac.init(KeyParameter(Uint8List.fromList(key)));

    // 生成签名
    final signatureBytes = hmac.process(Uint8List.fromList(messageBytes));

    // 返回 Base64 编码的签名
    return base64Encode(signatureBytes);
  }

  @override
  bool verify(ApiSignatureRequest request, String secretKey, String signText) {
    return sign(request, secretKey) == signText;
  }

}
