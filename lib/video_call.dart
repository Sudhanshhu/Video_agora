import 'dart:math';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class SimpleVideoCallScreen extends StatefulWidget {
  final String appId;
  final String token;
  final String channelName;

  const SimpleVideoCallScreen(
      {super.key,
      required this.appId,
      required this.token,
      required this.channelName});

  @override
  State<SimpleVideoCallScreen> createState() => _SimpleVideoCallScreenState();
}

class _SimpleVideoCallScreenState extends State<SimpleVideoCallScreen> {
  late final RtcEngine _engine;

  int? _localUid;
  int? _remoteUid;
  bool _joined = false;

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    // 1. Ask for permissions
    await [Permission.camera, Permission.microphone].request();

    // 2. Create engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: widget.appId));

    // 3. Enable video
    await _engine.enableVideo();

    // 4. Register event handlers
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

    // 5. Join the channel
    await _engine.startPreview();

    final randomUid = Random().nextInt(100000); // unique UID for each device

    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: randomUid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
      ),
    );
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
      appBar: AppBar(title: const Text('Simple Agora Video Call')),
      backgroundColor: Colors.black,
      body: Center(
        child: _joined
            ? Stack(
                children: [
                  // Remote video
                  Positioned.fill(
                    child: _remoteUid != null
                        ? AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: _engine,
                              canvas: VideoCanvas(uid: _remoteUid),
                              connection:
                                  RtcConnection(channelId: widget.channelName),
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Waiting for remote user...',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                  ),
                  // Local video (small preview in corner)
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
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          _engine.leaveChannel();
          Navigator.pop(context);
        },
        child: const Icon(Icons.call_end),
      ),
    );
  }
}
