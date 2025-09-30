import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ecommerce/core/constants/agora_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  // Display remote participants in a grid
  Widget buildVideoGrid(CallState state) {
    final participants = state.participants;

    if (participants.isEmpty || state.rtcEngine == null) {
      return const Center(
        child: Text(
          'Waiting for remote users...',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
    final int? screenShareId =
        participants.any((p) => p.uid == AgoraConfig().screenShareUid)
            ? AgoraConfig().screenShareUid
            : null;
    if (screenShareId != null) {
      final screenSharer = participants.firstWhere(
          (p) => p.uid == screenShareId,
          orElse: () => participants[0]);
      return Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: AgoraVideoView(
                controller: screenSharer.isLocal
                    ? VideoViewController(
                        rtcEngine: state.rtcEngine!,
                        canvas: VideoCanvas(uid: screenSharer.uid),
                      )
                    : VideoViewController.remote(
                        rtcEngine: state.rtcEngine!,
                        connection:
                            RtcConnection(channelId: widget.channelName),
                        canvas: VideoCanvas(uid: screenSharer.uid),
                      ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: participants
                  .where((p) => p.uid != screenSharer.uid)
                  .map((participant) => Container(
                        width: 120,
                        margin: const EdgeInsets.all(4),
                        color: Colors.black,
                        child: AgoraVideoView(
                          controller: participant.isLocal
                              ? VideoViewController(
                                  rtcEngine: state.rtcEngine!,
                                  canvas: VideoCanvas(uid: participant.uid),
                                )
                              : VideoViewController.remote(
                                  rtcEngine: state.rtcEngine!,
                                  connection: RtcConnection(
                                      channelId: widget.channelName),
                                  canvas: VideoCanvas(uid: participant.uid),
                                ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      );
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: participants.length <= 2
            ? 1
            : 2, // 1 column if 1-2 participants, 2 columns if more
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        final participant = participants[index];
        return Container(
          color: Colors.black,
          child: AgoraVideoView(
            controller: participant.isLocal
                ? VideoViewController(
                    rtcEngine: state.rtcEngine!,
                    canvas: VideoCanvas(uid: participant.uid),
                  )
                : VideoViewController.remote(
                    rtcEngine: state.rtcEngine!,
                    connection: RtcConnection(channelId: widget.channelName),
                    canvas: VideoCanvas(uid: participant.uid),
                  ),
          ),
        );
      },
    );
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
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Positioned.fill(child: buildVideoGrid(state)),

                // Floating local preview
                if (state.rtcEngine != null)
                  Positioned(
                    right: 20,
                    top: 40,
                    width: 120,
                    height: 160,
                    child: AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: state.rtcEngine!,
                        canvas: const VideoCanvas(uid: 0),
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
                          heroTag: "switchCamera",
                          onPressed: () {
                            context.read<CallBloc>().add(SwitchCameraEvent());
                          },
                          backgroundColor: Colors.indigo,
                          child: const Icon(Icons.switch_camera),
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
                        Text("${state.participants.length}"),
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
