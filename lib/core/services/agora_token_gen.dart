import 'dart:convert';
import 'package:crypto/crypto.dart';

class AgoraTokenGenerator {
  final String appId;
  final String appCertificate;

  AgoraTokenGenerator({required this.appId, required this.appCertificate});

  /// Generate token for a given channel and uid
  String generateToken({
    required String channelName,
    required int uid,
    int expireTimeInSeconds = 3600, // 1 hour default
  }) {
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expireTimestamp = currentTime + expireTimeInSeconds;

    final String signString =
        "$appId$channelName$uid$expireTimestamp$appCertificate";

    final hmac = Hmac(sha256, utf8.encode(appCertificate));
    final digest = hmac.convert(utf8.encode(signString));

    return base64Encode(digest.bytes);
  }
}
