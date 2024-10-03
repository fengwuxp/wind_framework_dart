import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import "package:asn1lib/asn1lib.dart";
import 'package:pointycastle/export.dart';

/// Helper class to handle RSA key generation, encoding, decoding, encrypting
/// and decrypting strings

/// Generates a [SecureRandom] to use in computing RSA key pair
///
/// Returns [FortunaRandom] to be used in the [AsymmetricKeyPair] generation
SecureRandom getSecureRandom() {
  var secureRandom = FortunaRandom();
  var random = Random.secure();
  List<int> seeds = [];
  for (int i = 0; i < 32; i++) {
    seeds.add(random.nextInt(255));
  }
  secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
  return secureRandom;
}

/// Decode Public key from PEM Format
///
/// Given a base64 encoded PEM [String] with correct headers and footers, return a
/// [RSAPublicKey]
///
/// *PKCS1*
/// RSAPublicKey ::= SEQUENCE {
///    modulus           INTEGER,  -- n
///    publicExponent    INTEGER   -- e
/// }
///
/// *PKCS8*
/// PublicKeyInfo ::= SEQUENCE {
///   algorithm       AlgorithmIdentifier,
///   PublicKey       BIT STRING
/// }
///
/// AlgorithmIdentifier ::= SEQUENCE {
///   algorithm       OBJECT IDENTIFIER,
///   parameters      ANY DEFINED BY algorithm OPTIONAL
/// }
RSAPublicKey parsePublicKeyFromPem(pemString) {
  return parsePublicKey(_removePemHeaderAndFooter(pemString));
}

RSAPublicKey parsePublicKey(String key) {
  ASN1Parser asn1Parser = ASN1Parser(base64.decode(key));
  ASN1Sequence topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

  ASN1Integer modulus, exponent;
  // Depending on the first element type, we either have PKCS1 or 2
  if (topLevelSeq.elements[0].runtimeType == ASN1Integer) {
    modulus = topLevelSeq.elements[0] as ASN1Integer;
    exponent = topLevelSeq.elements[1] as ASN1Integer;
  } else {
    final publicKeyBitString = topLevelSeq.elements[1];

    final publicKeyAsn = ASN1Parser(publicKeyBitString.contentBytes());
    ASN1Sequence publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    modulus = publicKeySeq.elements[0] as ASN1Integer;
    exponent = publicKeySeq.elements[1] as ASN1Integer;
  }

  return RSAPublicKey(modulus.valueAsBigInteger, exponent.valueAsBigInteger);
  ;
}

/// Decode Private key from PEM Format
///
/// Given a base64 encoded PEM [String] with correct headers and footers, return a
/// [RSAPrivateKey]
RSAPrivateKey parsePrivateKeyFromPem(pemString) {
  return parsePrivateKey(_removePemHeaderAndFooter(pemString));
}

RSAPrivateKey parsePrivateKey(String key) {
  var asn1Parser = ASN1Parser(base64.decode(key));
  var topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

  ASN1Integer modulus, privateExponent, p, q;
  //Use either PKCS1 or PKCS8 depending on the number of ELEMENTS
  if (topLevelSeq.elements.length == 3) {
    var privateKey = topLevelSeq.elements[2];

    asn1Parser = ASN1Parser(privateKey.contentBytes());
    var pkSeq = asn1Parser.nextObject() as ASN1Sequence;

    modulus = pkSeq.elements[1] as ASN1Integer;
    privateExponent = pkSeq.elements[3] as ASN1Integer;
    p = pkSeq.elements[4] as ASN1Integer;
    q = pkSeq.elements[5] as ASN1Integer;
  } else {
    modulus = topLevelSeq.elements[1] as ASN1Integer;
    privateExponent = topLevelSeq.elements[3] as ASN1Integer;
    p = topLevelSeq.elements[4] as ASN1Integer;
    q = topLevelSeq.elements[5] as ASN1Integer;
  }

  RSAPrivateKey rsaPrivateKey = RSAPrivateKey(
      modulus.valueAsBigInteger, privateExponent.valueAsBigInteger, p.valueAsBigInteger, q.valueAsBigInteger);

  return rsaPrivateKey;
}

String _removePemHeaderAndFooter(String pem) {
  const startsWith = [
    "-----BEGIN PUBLIC KEY-----",
    "-----BEGIN RSA PRIVATE KEY-----",
    "-----BEGIN RSA PUBLIC KEY-----",
    "-----BEGIN PRIVATE KEY-----",
    "-----BEGIN PGP PUBLIC KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
    "-----BEGIN PGP PRIVATE KEY BLOCK-----\r\nVersion: React-Native-OpenPGP.js 0.1\r\nComment: http://openpgpjs.org\r\n\r\n",
  ];
  const endsWith = [
    "-----END PUBLIC KEY-----",
    "-----END PRIVATE KEY-----",
    "-----END RSA PRIVATE KEY-----",
    "-----END RSA PUBLIC KEY-----",
    "-----END PGP PUBLIC KEY BLOCK-----",
    "-----END PGP PRIVATE KEY BLOCK-----",
  ];
  bool isOpenPgp = pem.contains('BEGIN PGP');

  pem = pem.replaceAll(' ', '');
  pem = pem.replaceAll('\n', '');
  pem = pem.replaceAll('\r', '');

  for (var s in startsWith) {
    s = s.replaceAll(' ', '');
    if (pem.startsWith(s)) {
      pem = pem.substring(s.length);
    }
  }

  for (var s in endsWith) {
    s = s.replaceAll(' ', '');
    if (pem.endsWith(s)) {
      pem = pem.substring(0, pem.length - s.length);
    }
  }

  if (isOpenPgp) {
    var index = pem.indexOf('\r\n');
    pem = pem.substring(0, index);
  }

  return pem;
}

/// Encode Private key to PEM Format
///
/// Given [RSAPrivateKey] returns a base64 encoded [String] with standard PEM headers and footers
String encodePrivateKeyToPemPKCS1(RSAPrivateKey privateKey) {
  return """-----BEGIN RSA PRIVATE KEY-----\r\n${encodePrivateKeyToPKCS1(privateKey)}\r\n-----END RSA PRIVATE KEY-----""";
}

String encodePrivateKeyToPKCS1(RSAPrivateKey privateKey) {
  final topLevel = ASN1Sequence();
  final version = ASN1Integer(BigInt.from(0));
  final modulus = ASN1Integer(privateKey.n!);
  final publicExponent = ASN1Integer(privateKey.exponent!);
  final privateExponent = ASN1Integer(privateKey.privateExponent!);
  final p = ASN1Integer(privateKey.p!);
  final q = ASN1Integer(privateKey.q!);
  final dP = privateKey.privateExponent! % (privateKey.p! - BigInt.from(1));
  final exp1 = ASN1Integer(dP);
  final dQ = privateKey.privateExponent! % (privateKey.q! - BigInt.from(1));
  final exp2 = ASN1Integer(dQ);
  final iQ = privateKey.q!.modInverse(privateKey.p!);
  final co = ASN1Integer(iQ);

  topLevel.add(version);
  topLevel.add(modulus);
  topLevel.add(publicExponent);
  topLevel.add(privateExponent);
  topLevel.add(p);
  topLevel.add(q);
  topLevel.add(exp1);
  topLevel.add(exp2);
  topLevel.add(co);
  return base64.encode(topLevel.encodedBytes);
}

/// Encode Public key to PEM Format
///
/// Given [RSAPublicKey] returns a base64 encoded [String] with standard PEM headers and footers
String encodePublicKeyToPemPKCS1(RSAPublicKey publicKey) {
  return """-----BEGIN RSA PUBLIC KEY-----\r\n${encodePublicKeyToPKCS1(publicKey)}\r\n-----END RSA PUBLIC KEY-----""";
}

String encodePublicKeyToPKCS1(RSAPublicKey publicKey) {
  final topLevel = ASN1Sequence();
  topLevel.add(ASN1Integer(publicKey.modulus!));
  topLevel.add(ASN1Integer(publicKey.exponent!));
  final dataBase64 = base64.encode(topLevel.encodedBytes);
  return dataBase64;
}

/// Generate a [PublicKey] and [PrivateKey] pair
///
/// Returns a [AsymmetricKeyPair] based on the [RSAKeyGenerator] with custom parameters,
/// including a [SecureRandom]
AsymmetricKeyPair<PublicKey, PrivateKey> getRsaKeyPair(SecureRandom secureRandom) {
  /// Set BitStrength to [1024, 2048 or 4096]
  final rsapars = RSAKeyGeneratorParameters(BigInt.from(65537), 2048, 5);
  final params = ParametersWithRandom(rsapars, secureRandom);
  final keyGenerator = RSAKeyGenerator();
  keyGenerator.init(params);
  return keyGenerator.generateKeyPair();
}
