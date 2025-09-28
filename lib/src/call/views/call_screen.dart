import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc/call_bloc.dart';
import 'bloc/call_event.dart';
import 'bloc/call_state.dart';

class CallScreen extends StatefulWidget {
  final String token;
  final String channelName;
  final String appId;

  const CallScreen({
    super.key,
    required this.token,
    required this.channelName,
    required this.appId,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CallBloc()
        ..add(InitializeCallEvent(
          token: widget.token,
          channelName: widget.channelName,
          appId: widget.appId,
        )),
      child: BlocBuilder<CallBloc, CallState>(
        builder: (context, state) {
          if (state.errorMessage?.isNotEmpty ?? false) {
            return Center(child: Text("ERROR${state.errorMessage}"));
          }
          Widget videoWidget;
          if (state.participants.isNotEmpty && state.rtcEngine != null) {
            final remoteUid = state.participants.last.uid;
            videoWidget = AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: state.rtcEngine!,
                canvas: VideoCanvas(uid: remoteUid),
                connection: RtcConnection(channelId: widget.channelName),
              ),
            );
          } else {
            videoWidget = const Center(
              child: Text(
                'Waiting for remote user...',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Positioned.fill(child: videoWidget),
                if (state.rtcEngine != null)
                  Positioned(
                    right: 20,
                    top: 40,
                    width: 120,
                    height: 160,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: state.rtcEngine!,
                        canvas: const VideoCanvas(
                          uid: 0,
                        ),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Mute / Unmute
                        FloatingActionButton(
                          heroTag: "mute",
                          onPressed: () =>
                              context.read<CallBloc>().add(ToggleMuteEvent()),
                          backgroundColor: Colors.white,
                          child: Icon(
                            state.isMuted ? Icons.mic_off : Icons.mic,
                            color: Colors.black,
                          ),
                        ),

                        // Screen Share
                        FloatingActionButton(
                          heroTag: "screen",
                          onPressed: () => context
                              .read<CallBloc>()
                              .add(ToggleScreenShareEvent()),
                          backgroundColor: Colors.white,
                          child: Icon(
                            state.isScreenSharing
                                ? Icons.stop_screen_share
                                : Icons.screen_share,
                            color: Colors.black,
                          ),
                        ),

                        // End Call
                        FloatingActionButton(
                          onPressed: () {
                            context.read<CallBloc>().add(EndCallEvent());
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.red,
                          child: const Icon(Icons.call_end),
                        ),
                        Text("AAA ${state.participants.length}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
