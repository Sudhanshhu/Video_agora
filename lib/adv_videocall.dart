import 'dart:math';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AdvancedVideoCallScreen extends StatefulWidget {
  final String appId;
  final String token;
  final String channelName;
  const AdvancedVideoCallScreen(
      {super.key,
      required this.appId,
      required this.token,
      required this.channelName});

  @override
  State<AdvancedVideoCallScreen> createState() =>
      _AdvancedVideoCallScreenState();
}

class _AdvancedVideoCallScreenState extends State<AdvancedVideoCallScreen> {
  // Replace with your Agora credentials

  String channelName = "";

  late final RtcEngine _engine;

  int? _localUid;
  int? _remoteUid;

  bool _joined = false;
  bool _isMuted = false;
  bool _isVideoDisabled = false;
  bool _isScreenSharing = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    // Request camera and microphone permissions
    channelName = widget.channelName;
    await [Permission.camera, Permission.microphone].request();

    // Create Agora engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: widget.appId));

    // Enable video
    await _engine.enableVideo();

    // Register event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user joined: ${connection.localUid}");
          setState(() {
            _joined = true;
            _localUid = connection.localUid;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user joined: $remoteUid");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("Remote user left: $remoteUid");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    // Start preview before joining
    await _engine.startPreview();

    final randomUid = Random().nextInt(100000); // unique UID for each device

    // Join channel
    await _engine.joinChannel(
      token: widget.token,
      channelId: channelName,
      uid: randomUid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
  }

  /// Toggle microphone mute/unmute
  Future<void> _toggleMute() async {
    setState(() => _isMuted = !_isMuted);
    await _engine.muteLocalAudioStream(_isMuted);
  }

  /// Toggle video on/off
  Future<void> _toggleVideo() async {
    setState(() => _isVideoDisabled = !_isVideoDisabled);
    await _engine.muteLocalVideoStream(_isVideoDisabled);
  }

  /// Switch between front and rear camera
  Future<void> _switchCamera() async {
    await _engine.switchCamera();
  }

  /// Toggle screen sharing (mobile only supported on Android with Agora extensions)
  Future<void> _toggleScreenShare() async {
    if (_isScreenSharing) {
      await _engine.stopScreenCapture();
      setState(() => _isScreenSharing = false);
    } else {
      // This requires extra setup for screen capture on mobile
      await _engine.startScreenCapture(
        const ScreenCaptureParameters2(
          captureVideo: true,
          captureAudio: true,
        ),
      );
      setState(() => _isScreenSharing = true);
    }
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Agora Video Call"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Remote user video
          Positioned.fill(
            child: _remoteUid != null
                ? AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: _engine,
                      canvas: VideoCanvas(uid: _remoteUid),
                      connection: RtcConnection(channelId: channelName),
                    ),
                  )
                : const Center(
                    child: Text(
                      'Waiting for remote user...',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
          ),

          // Local user video (small corner preview)
          if (!_isVideoDisabled)
            Positioned(
              right: 20,
              top: 40,
              width: 120,
              height: 160,
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            ),

          // Bottom control buttons
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Mute/Unmute Mic
                _buildControlButton(
                  icon: _isMuted ? Icons.mic_off : Icons.mic,
                  color: _isMuted ? Colors.red : Colors.white,
                  onPressed: _toggleMute,
                ),

                // Toggle Video
                _buildControlButton(
                  icon: _isVideoDisabled ? Icons.videocam_off : Icons.videocam,
                  color: _isVideoDisabled ? Colors.red : Colors.white,
                  onPressed: _toggleVideo,
                ),

                // End Call
                _buildControlButton(
                  icon: Icons.call_end,
                  color: Colors.red,
                  onPressed: () {
                    _engine.leaveChannel();
                    Navigator.pop(context);
                  },
                ),

                // Switch Camera
                _buildControlButton(
                  icon: Icons.cameraswitch,
                  color: Colors.white,
                  onPressed: _switchCamera,
                ),

                // Screen Share
                _buildControlButton(
                  icon: _isScreenSharing
                      ? Icons.stop_screen_share
                      : Icons.screen_share,
                  color: _isScreenSharing ? Colors.red : Colors.white,
                  onPressed: _toggleScreenShare,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey.withOpacity(0.3),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
