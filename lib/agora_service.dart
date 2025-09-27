import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';

class AgoraService {
  final String appId =
      "6e64b833fca54dbeb104f52653e590f8"; // Replace with your Agora App ID
  RtcEngine? _engine;

  // ✅ Add a public getter
  RtcEngine? get engine => _engine;

  Future<void> initialize() async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: "6e64b833fca54dbeb104f52653e590f8",
    ));

    // Enable video
    await _engine!.enableVideo();

    // Set event handlers
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          debugPrint("Successfully joined channel: ${connection.channelId}");
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          debugPrint("Remote user joined: $remoteUid");
        },
        onUserOffline: (connection, remoteUid, reason) {
          debugPrint("Remote user left: $remoteUid");
        },
      ),
    );
  }

  Future<void> joinChannel(String token, String channelName, int uid) async {
    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await _engine!.leaveChannel();
  }

  Future<void> dispose() async {
    await _engine!.release();
    _engine = null;
  }
}
