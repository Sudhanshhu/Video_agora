import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../constants/app_config.dart';

class AgoraService {
  late final RtcEngine _engine;
  final bool _initialized = false;

  RtcEngine get engine => _engine;

  Future<void> initialize() async {
    if (_initialized) return;

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(appId: AppConfig().appId),
    );

    await _engine.enableVideo();
    await _engine.enableAudio();

    // _initialized = true;
  }

  Future<void> joinChannel(
      {required String token,
      required String channelName,
      required int uid,
      required ChannelMediaOptions options}) async {
    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: options,
    );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }

  Future<void> muteLocalAudio(bool mute) async {
    await _engine.muteLocalAudioStream(mute);
  }

  /// Start Screen Sharing
  Future<void> startScreenShare({
    required String token,
    required String channelName,
    required int screenShareUid,
  }) async {
    await _engine.startScreenCapture(
      const ScreenCaptureParameters2(
        captureAudio: true,
        captureVideo: true,
        audioParams: ScreenAudioParameters(
          sampleRate: 44100,
          channels: 2,
        ),
        videoParams: ScreenVideoParameters(
          dimensions: VideoDimensions(width: 1280, height: 720),
          frameRate: 30,
          bitrate: 4000,
        ),
      ),
    );

    await _engine.joinChannel(
      token: token,
      channelId: channelName,
      uid: screenShareUid,
      options: const ChannelMediaOptions(
        publishScreenTrack: true,
        publishCameraTrack: false,
      ),
    );
  }

  Future<void> stopScreenShare() async {
    await _engine.stopScreenCapture();
  }
}
