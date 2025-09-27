import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'agora_service.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final String token;
  final int uid;

  const CallScreen({
    super.key,
    required this.channelName,
    required this.token,
    required this.uid,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final AgoraService _agoraService = AgoraService();
  bool localUserJoined = false;
  int? remoteUid;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    await _agoraService.initialize();

    // Use engine through the getter now
    _agoraService.engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            localUserJoined = true;
          });
        },
        onUserJoined: (connection, uid, elapsed) {
          setState(() {
            remoteUid = uid;
          });
        },
        onUserOffline: (connection, uid, reason) {
          setState(() {
            remoteUid = null;
          });
        },
      ),
    );

    await _agoraService.joinChannel(
      widget.token,
      widget.channelName,
      widget.uid,
    );
  }

  @override
  void dispose() {
    _agoraService.leaveChannel();
    _agoraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Show remote video
          remoteUid != null
              ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: _agoraService.engine!,
                    canvas: VideoCanvas(uid: remoteUid),
                    connection: RtcConnection(channelId: widget.channelName),
                  ),
                )
              : const Center(child: Text('Waiting for remote user...')),

          // Show local video in a small preview
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 120,
              height: 160,
              child: localUserJoined
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _agoraService.engine!,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),

          // End call button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: FloatingActionButton(
                onPressed: () {
                  _agoraService.leaveChannel();
                  Navigator.pop(context);
                },
                child: const Icon(Icons.call_end, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
