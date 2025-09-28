import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ecommerce/core/toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/participants.dart';
import 'call_event.dart';
import 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  // Keep track of screen share UID separately
  static const int _screenShareUid = 2001;

  late String _channelName;
  late String _token;
  late int _localUid;
  late final RtcEngine _engine;

  CallBloc() : super(const CallState()) {
    on<InitializeCallEvent>(_onInitializeCall);
    on<UserJoinedEvent>(_onUserJoined);
    on<UserLeftEvent>(_onUserLeft);
    on<ToggleMuteEvent>(_onToggleMute);
    on<ToggleScreenShareEvent>(_onToggleScreenShare);
    on<EndCallEvent>(_onEndCall);
  }

  /// Initialize Agora and join the channel
  Future<void> _onInitializeCall(
    InitializeCallEvent event,
    Emitter<CallState> emit,
  ) async {
    _token = event.token;
    _channelName = event.channelName;
    // _localUid = event.localUid;

    await [Permission.camera, Permission.microphone].request();

    if (await (Permission.camera.isDenied) ||
        await Permission.microphone.isDenied) {
      return emit(state.copyWith(errorMessage: "Please give permission"));
    }

    // Create Agora engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: event.appId));

    // Enable video
    await _engine.enableVideo();

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          fToast(
              "joined successfully  ${connection.localUid} Channel $_channelName",
              type: AlertType.success);
          add(UserJoinedEvent(Participant(
              uid: connection.localUid ?? _localUid, isLocal: true)));
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          fToast("Remote user id $remoteUid");
          add(UserJoinedEvent(Participant(uid: remoteUid, isLocal: false)));
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          fToast("Left $remoteUid");
          add(UserLeftEvent(remoteUid));
        },
        onError: (err, msg) {
          fToast("Agora Error: $err - $msg", type: AlertType.failure);
          emit(state.copyWith(errorMessage: err.name));
        },
      ),
    );

    // Start preview before joining
    await _engine.startPreview();

    final randomUid = Random().nextInt(100000);

    await _engine.joinChannel(
      token: _token,
      channelId: _channelName,
      uid: randomUid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
      ),
    );
    emit(state.copyWith(isCallActive: true, rtcEngine: _engine));
  }

  void _onUserJoined(UserJoinedEvent event, Emitter<CallState> emit) {
    final updatedList = List<Participant>.from(state.participants)
      ..add(event.participant);
    emit(state.copyWith(participants: updatedList));
  }

  void _onUserLeft(UserLeftEvent event, Emitter<CallState> emit) {
    final updatedList =
        state.participants.where((p) => p.uid != event.uid).toList();
    emit(state.copyWith(participants: updatedList));
  }

  /// Toggle mute/unmute local audio
  Future<void> _onToggleMute(
      ToggleMuteEvent event, Emitter<CallState> emit) async {
    final newMutedState = !state.isMuted;
    await _engine.muteLocalAudioStream(newMutedState);
    emit(state.copyWith(isMuted: newMutedState));
  }

  /// Start or stop screen sharing
  Future<void> _onToggleScreenShare(
      ToggleScreenShareEvent event, Emitter<CallState> emit) async {
    final currentlySharing = state.isScreenSharing;

    if (currentlySharing) {
      await _engine.stopScreenCapture();
      emit(state.copyWith(isScreenSharing: false));
      add(UserLeftEvent(_screenShareUid));
    } else {
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

      emit(state.copyWith(isScreenSharing: true));
      add(UserJoinedEvent(Participant(
          uid: _screenShareUid, isLocal: true, isScreenSharing: true)));
    }
  }

  /// End the call and cleanup
  Future<void> _onEndCall(EndCallEvent event, Emitter<CallState> emit) async {
    _engine.leaveChannel();
    _engine.release();
    emit(const CallState(participants: [], isCallActive: false));
  }
}
